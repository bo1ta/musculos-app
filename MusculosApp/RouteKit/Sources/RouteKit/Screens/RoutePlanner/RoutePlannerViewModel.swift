//
//  RoutePlannerViewModel.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 03.01.2025.
//

import Combine
import CoreLocation
import Factory
import Foundation
import MapKit
import Observation
import Utility

@MainActor
@Observable
final class RoutePlannerViewModel {
  @ObservationIgnored
  @LazyInjected(\RouteKitContainer.mapKitClient) private var client: MapKitClient

  var averagePace: Double = 0
  var showRouteForm = false
  var currentLocation: CLLocation?
  var mapItemResults: [MapItemData] = []
  var selectedMapItem: MapItemData?
  var currentRoute: MKRoute?
  var currentWizardStep = RoutePlannerWizardStep.search
  var startLocation = ""

  var currentPlacemark: CLPlacemark? {
    didSet {
      if let name = currentPlacemark?.name {
        startLocation = name
      }
    }
  }

  var endLocation = "" {
    didSet {
      currentQuerySubject.send(endLocation)
    }
  }

  private var searchTask: Task<Void, Never>?
  private var routeTask: Task<Void, Never>?
  private let currentQuerySubject = PassthroughSubject<String, Never>()
  private var cancellables: Set<AnyCancellable> = []

  init() {
    currentQuerySubject.eraseToAnyPublisher()
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink { [weak self] query in
        self?.searchQuery(query)
      }
      .store(in: &cancellables)
  }

  func onDisappear() {
    searchTask?.cancel()
    routeTask?.cancel()
  }

  // MARK: Search query

  func searchQuery(_ query: String) {
    guard let currentLocation, !endLocation.isEmpty else {
      mapItemResults.removeAll()
      return
    }

    searchTask = Task {
      do {
        mapItemResults = try await getMapItemsForQuery(query, on: currentLocation)
      } catch {
        Logger.error(error, message: "Could not perform search using MapKitClient")
      }
    }
  }

  nonisolated private func getMapItemsForQuery(_ query: String, on location: CLLocation) async throws -> [MapItemData] {
    let coordinateSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, span: coordinateSpan)
    let mapItems = try await client.getLocationsByQuery(query, on: coordinateRegion)
    return Array(mapItems.prefix(4))
  }

  // MARK: Update route

  func setRouteForItem(_ item: MapItemData) {
    guard let currentLocation else {
      return
    }

    routeTask = Task {
      do {
        async let directionsTask = getDirections(from: currentLocation.coordinate, to: item.placemark.coordinate)
        async let locationDetailsTask = getLocationDetails(currentLocation)

        let (directions, currentLocationDetails) = try await (directionsTask, locationDetailsTask)
        selectedMapItem = item
        currentRoute = directions.routes.first
        currentPlacemark = currentLocationDetails.first
        currentWizardStep = .confirm

      } catch {
        Logger.error(error, message: "Could not retrieve route")
      }
    }
  }

  nonisolated private func getDirections(
    from startLocation: CLLocationCoordinate2D,
    to endLocation: CLLocationCoordinate2D)
    async throws -> MKDirections.Response
  {
    try await client.getDirections(from: startLocation, to: endLocation)
  }

  nonisolated private func getLocationDetails(_ location: CLLocation) async throws -> [CLPlacemark] {
    try await client.getLocationDetails(location)
  }
}

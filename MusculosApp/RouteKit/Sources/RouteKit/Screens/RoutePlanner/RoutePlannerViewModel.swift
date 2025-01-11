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
  struct RouteState {
    var originItem: MapItemData?
    var destinationItem: MapItemData?
    var route: MKRoute?
  }

  @ObservationIgnored
  @LazyInjected(\RouteKitContainer.mapKitClient) private var client: MapKitClient

  private(set) var routeState: RouteState?

  var averagePace: Double = 0
  var showRouteForm = false
  var currentLocation: CLLocation?
  var queryResults: [MapItemData] = []
  var destinationMapItem: MapItemData?
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
      queryResults.removeAll()
      return
    }

    searchTask = Task {
      do {
        queryResults = try await getMapItemsForQuery(query, on: currentLocation)
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
        currentPlacemark = try await getLocationDetails(currentLocation)?.placemark

        let origin = currentLocation.coordinate
        let destination = item.placemark.coordinate
        let directions = try await getDirections(from: origin, to: destination)

        currentRoute = directions.routes.first
        destinationMapItem = item
        currentWizardStep = .confirm

      } catch {
        Logger.error(error, message: "Could not retrieve route")
      }
    }
  }

  nonisolated private func getDirections(
    from origin: CLLocationCoordinate2D,
    to destination: CLLocationCoordinate2D)
    async throws -> DirectionData
  {
    try await client.getDirections(from: origin, to: destination)
  }

  nonisolated private func getLocationDetails(_ location: CLLocation) async throws -> MapItemData? {
    try await client.getLocationDetails(location)
  }
}

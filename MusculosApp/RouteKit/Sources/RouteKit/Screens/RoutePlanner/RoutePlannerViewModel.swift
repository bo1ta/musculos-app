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
  var currentRoute: MKRoute?
  var startLocation = ""

  var endLocation = "" {
    didSet {
      currentQuerySubject.send(endLocation)
    }
  }

  private let currentQuerySubject = PassthroughSubject<String, Never>()
  private var cancellables: Set<AnyCancellable> = []
  private var searchTask: Task<Void, Never>?
  private var routeTask: Task<Void, Never>?

  init() {
    currentQuerySubject.eraseToAnyPublisher()
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink { [weak self] query in
        self?.searchQuery(query)
      }
      .store(in: &cancellables)
  }

  func searchQuery(_ query: String) {
    guard let currentLocation, !endLocation.isEmpty else {
      mapItemResults.removeAll()
      return
    }

    searchTask?.cancel()

    searchTask = Task { [weak self] in
      guard let self else {
        return
      }

      do {
        try Task.checkCancellation()

        let coordinateRegion = MKCoordinateRegion(
          center: currentLocation.coordinate,
          span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))

        let result = try await client.getLocationsByQuery(endLocation, on: coordinateRegion)
        mapItemResults = Array(result.prefix(3))
      } catch {
        Logger.error(error, message: "Could not perform search using MapKitClient")
      }
    }
  }

  func setRouteForItem(_ item: MapItemData) {
    guard let currentLocation else {
      return
    }

    routeTask?.cancel()

    routeTask = Task { [weak self] in
      guard let self else {
        return
      }

      do {
        try Task.checkCancellation()

        let response = try await client.getDirections(from: currentLocation.coordinate, to: item.placemark.coordinate)
        currentRoute = response.routes.first
      } catch {
        Logger.error(error, message: "Could not retrieve route")
      }
    }
  }

  func onDisappear() {
    searchTask?.cancel()
  }
}

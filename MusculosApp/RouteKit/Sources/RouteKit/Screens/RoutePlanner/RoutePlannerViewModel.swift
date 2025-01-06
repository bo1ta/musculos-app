//
//  RoutePlannerViewModel.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 03.01.2025.
//

import Combine
import CoreLocation
import Foundation
import MapKit
import Observation
import Utility

@MainActor
@Observable
final class RoutePlannerViewModel {
  var averagePace: Double = 0
  var showRouteForm = false
  var startLocation = ""
  var endLocation = "" {
    didSet {
      currentQuerySubject.send(endLocation)
    }
  }

  var currentLocation: CLLocation?
  var mapItemResults: [MapItemResult] = []
  var currentRoute: MKRoute?

  private let currentQuerySubject = PassthroughSubject<String, Never>()
  private var cancellables: Set<AnyCancellable> = []
  private var client: MapKitClient

  private var searchTask: Task<Void, Never>?
  private var routeTask: Task<Void, Never>?

  init() {
    client = MapKitClient()

    setupQueryObserver()
  }

  private func setupQueryObserver() {
    currentQuerySubject.eraseToAnyPublisher()
      .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
      .sink { [weak self] _ in
        self?.searchQuery()
      }
      .store(in: &cancellables)
  }

  func searchQuery() {
    guard let currentLocation, !endLocation.isEmpty else {
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

  func setRouteForItem(_ item: MapItemResult) {
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
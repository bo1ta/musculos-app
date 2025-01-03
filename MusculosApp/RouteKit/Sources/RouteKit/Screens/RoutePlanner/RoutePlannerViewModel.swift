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

  private let currentQuerySubject = PassthroughSubject<String, Never>()
  private var searchTask: Task<Void, Never>?
  private var cancellables: Set<AnyCancellable> = []
  private var client: MapKitClient

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

    searchTask = Task { [weak self] in
      guard let self else {
        return
      }

      do {
        let coordinateRegion = MKCoordinateRegion(
          center: currentLocation.coordinate,
          span: .init(latitudeDelta: 0.1, longitudeDelta: 0.1))
        let result = try await client.getLocationsByQuery(endLocation, on: coordinateRegion)
        Logger.info(message: "Found results: \(result)")
        mapItemResults = result

      } catch {
        Logger.error(error, message: "Could not perform search using MapKitClient")
      }
    }
  }

  func onDisappear() {
    searchTask?.cancel()
  }
}

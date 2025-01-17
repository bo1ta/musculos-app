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

enum MapCameraType {
  case walking
  case planning
}

@MainActor
@Observable
final class RoutePlannerViewModel {

  @ObservationIgnored
  @LazyInjected(\RouteKitContainer.mapKitClient) private var client: MapKitClient

  var averagePace: Double = 0
  var showRouteForm = false
  var currentLocation: CLLocation?
  var queryResults: [MapItemData] = []
  var currentRoute: MKRoute?
  var wizardStep = RoutePlannerWizardStep.search
  var startLocation = ""
  var endLocation = ""
  var currentZoomLevel: CLLocationDistance = 0.01
  var mapCameraType: MapCameraType = .planning
  var elapsedTime = 0
  var isTimerActive = false

  var currentPlacemark: CLPlacemark? {
    didSet {
      if let name = currentPlacemark?.name {
        startLocation = name
      }
    }
  }

  var destinationMapItem: MapItemData? {
    didSet {
      if let destinationMapItem  {
        endLocation = destinationMapItem.name
      }
    }
  }

  var queryLocation = "" {
    didSet {
      currentQuerySubject.send(queryLocation)
    }
  }

  private var searchTask: Task<Void, Never>?
  private var routeTask: Task<Void, Never>?
  private var timerTask: Task<Void, Never>?
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

  func loadCurrentLocationData() async {
    guard let currentLocation else {
      return
    }
    do {
      let data = try await client.getLocationDetails(currentLocation)
      if let data {
        startLocation = data.name
      }
    } catch {
      Logger.error(error, message: "Error loading current location details")
    }
  }

  // MARK: Search query

  func searchQuery(_ query: String) {
    guard let currentLocation, !query.isEmpty else {
      queryResults.removeAll()
      return
    }

    searchTask = Task {
      do {
        queryResults = try await getMapItemsForQuery(query, on: currentLocation)
        if !queryResults.isEmpty {
          currentZoomLevel = 0.10
        }
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
        wizardStep = .confirm

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

  // MARK: Running + timer

  func startRunning() {
    guard wizardStep == .confirm else {
      return
    }

    wizardStep = .inProgress
    mapCameraType = .walking
    startTimer()
  }

  func stopRunning() {
    guard wizardStep == .inProgress else {
      return
    }

    resetQuery()
    stopTimer()
    wizardStep = .search
    mapCameraType = .planning
  }

  private func resetQuery() {
    queryResults.removeAll()
    queryLocation = ""
    endLocation = ""
  }

  func startTimer() {
    guard !isTimerActive else {
      Logger.warning(message: "Timer already running!")
      return
    }

    isTimerActive = true

    timerTask = Task { [weak self] in
      repeat {
        try? await Task.sleep(for: .seconds(1))
        self?.elapsedTime += 1
      } while !Task.isCancelled && self?.isTimerActive == true
    }
  }

  func stopTimer() {
    timerTask?.cancel()
    timerTask = nil
    isTimerActive = false
  }
}

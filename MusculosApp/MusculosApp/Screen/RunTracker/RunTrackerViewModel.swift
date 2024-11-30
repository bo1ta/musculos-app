//
//  RunTrackerViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.11.2024.
//

import Observation
import Combine
import CoreLocation
import Factory
import MapKit

@Observable
@MainActor
final class RunTrackerViewModel {

  @ObservationIgnored
  @Injected(\.locationManager) private var locationManager: LocationManagerProtocol

  private var cancellables = Set<AnyCancellable>()

  private(set) var currentLocationMapItem: MKMapItem?
  private(set) var currentLocation: CLLocation? = nil {
    didSet {
      guard let currentLocation, currentLocation != oldValue else {
        return
      }
      currentLocationMapItem = MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
    }
  }

  private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined {
    didSet {
      guard authorizationStatus == .authorizedWhenInUse else {
        return
      }
      startRunning()
    }
  }

  private(set) var isTracking = false

  private(set) var userCustomCoordinates: [CLLocationCoordinate2D] = []
  private(set) var mapItems: [MKMapItem] = []

  init() {
    locationManager.authorizationPublisher
      .sink { [weak self] authorizationStatus in
        self?.authorizationStatus = authorizationStatus
      }
      .store(in: &cancellables)

    locationManager.locationPublisher
      .sink { [weak self] location in
        self?.currentLocation = location
      }
      .store(in: &cancellables)
  }

  func initialLoad() {
    locationManager.requestLocationPermission()
  }

  private func startRunning() {
    locationManager.startTrackingLocation()
    isTracking = true
  }

  func addMapItem(_ coordinate: CLLocationCoordinate2D) {
    userCustomCoordinates.append(coordinate)
    let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: coordinate))
    mapItems.append(mapItem)
  }

  func getCurrentLocationMapItem() -> MKMapItem? {
    guard let currentLocation else { return nil }
    
    return MKMapItem(placemark: MKPlacemark(coordinate: currentLocation.coordinate))
  }

  private func stopRunning() {
    guard isTracking else { return }

    locationManager.stopTrackingLocation()
    isTracking = false
  }
}

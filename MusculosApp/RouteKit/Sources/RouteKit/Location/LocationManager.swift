//
//  LocationManager.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import Combine
import CoreLocation
import Utility

// MARK: - LocationManager

public final class LocationManager: NSObject, @unchecked Sendable {
  enum LocationError: Error {
    case authorizationDenied
  }

  private(set) var isTracking = false

  private let locationManager: CLLocationManager
  private let currentLocationSubject = CurrentValueSubject<CLLocation?, Never>(nil)
  private let locationHeadingSubject = PassthroughSubject<CLHeading, Never>()
  private let errorSubject = PassthroughSubject<Error, Never>()

  public var currentLocationPublisher: AnyPublisher<CLLocation?, Never> {
    currentLocationSubject.eraseToAnyPublisher()
  }

  public var locationHeadingPublisher: AnyPublisher<CLHeading, Never> {
    locationHeadingSubject.eraseToAnyPublisher()
  }

  public var errorPublisher: AnyPublisher<Error, Never> {
    errorSubject.eraseToAnyPublisher()
  }

  public var currentLocation: CLLocation? {
    currentLocationSubject.value
  }

  override public init() {
    locationManager = CLLocationManager()

    super.init()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
    locationManager.activityType = .fitness
    locationManager.pausesLocationUpdatesAutomatically = false
  }

  public func startTracking() {
    guard !isTracking else {
      return
    }
    defer { isTracking = true }

    locationManager.startUpdatingLocation()
    locationManager.startUpdatingHeading()
    Logger.info(message: "Started tracking location")
  }

  public func stopTracking() {
    guard isTracking else {
      return
    }
    defer { isTracking = false }

    locationManager.stopUpdatingLocation()
    Logger.info(message: "Stopped tracking location")
  }

  public func checkAuthorizationStatus() {
    switch locationManager.authorizationStatus {
    case .authorizedAlways, .authorizedWhenInUse:
      Logger.info(message: "Location authorization granted")
      startTracking()

    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()

    case .restricted, .denied:
      Logger.error(LocationError.authorizationDenied, message: "Location authorization restricted")
      errorSubject.send(LocationError.authorizationDenied)

    @unknown default:
      Logger.error(MusculosError.unknownError, message: "Unknown authorization status")
    }
  }
}

// MARK: CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
  public func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard isTracking, let newLocation = locations.last else {
      return
    }
    currentLocationSubject.send(newLocation)
  }

  public func locationManager(_: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
    locationHeadingSubject.send(newHeading)
  }

  public func locationManager(_: CLLocationManager, didFailWithError error: any Error) {
    Logger.error(error, message: "Location manager failed with error")
    errorSubject.send(error)
  }

  public func locationManagerDidChangeAuthorization(_: CLLocationManager) {
    guard !isTracking else {
      return
    }
    checkAuthorizationStatus()
  }
}

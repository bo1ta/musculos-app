//
//  LocationManager.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import CoreLocation
import Combine
import Utility

public final class LocationManager: NSObject, @unchecked Sendable {
  private enum LocationError: Error {
    case authorizationDenied
  }

  private(set) var isTracking = false
  private var locationContinuation: AsyncStream<CLLocation>.Continuation?

  lazy var locationStream: AsyncStream<CLLocation> = {
    AsyncStream { (continuation: AsyncStream<CLLocation>.Continuation) -> Void in
      self.locationContinuation = continuation
      self.locationContinuation?.onTermination = { [weak self] _ in
        self?.stopTracking()
      }
    }
  }()

  private let locationManager: CLLocationManager

  override public init() {
    locationManager = CLLocationManager()

    super.init()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  public func checkAuthorizationStatus() {
    switch locationManager.authorizationStatus {
    case .notDetermined:
      locationManager.requestWhenInUseAuthorization()
    case .restricted:
      Logger.error(LocationError.authorizationDenied, message: "Location authorization restricted")
    case .denied:
      Logger.error(LocationError.authorizationDenied, message: "Location authorization denied")
    case .authorizedAlways, .authorizedWhenInUse:
      startTracking()
    @unknown default:
      Logger.warning(message: "Unknown authorization status")
    }
  }

  private func startTracking() {
    locationManager.startUpdatingLocation()
    isTracking = true
    Logger.info(message: "LocationManager started tracking location")
  }

  private func stopTracking() {
    locationManager.stopUpdatingLocation()
    isTracking = false
    Logger.info(message: "LocationManager stopped tracking location")
  }
}

extension LocationManager: CLLocationManagerDelegate {
  public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    guard isTracking, let newLocation = locations.last else {
      return
    }
    locationContinuation?.yield(newLocation)
  }

  public func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    Logger.error(error, message: "Location manager failed with error")
    locationContinuation?.finish()
  }

  public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    checkAuthorizationStatus()
  }
}

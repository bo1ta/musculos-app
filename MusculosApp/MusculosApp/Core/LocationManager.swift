//
//  LocationManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.11.2024.
//

import Foundation
import CoreLocation
import Combine
import Utility

protocol LocationManagerProtocol {
  var locationPublisher: AnyPublisher<CLLocation?, Never> { get }
  var authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never> { get }

  func requestLocationPermission()
  func startTrackingLocation()
  func stopTrackingLocation()
}

class LocationManager: NSObject, LocationManagerProtocol {
  private let locationManager = CLLocationManager()
  private let locationSubject = CurrentValueSubject<CLLocation?, Never>(nil)
  private let authorizationSubject = CurrentValueSubject<CLAuthorizationStatus, Never>(.notDetermined)

  override init() {
    super.init()

    locationManager.delegate = self
    locationManager.desiredAccuracy = kCLLocationAccuracyBest
  }

  var locationPublisher: AnyPublisher<CLLocation?, Never> {
    return locationSubject.eraseToAnyPublisher()
  }

  var authorizationPublisher: AnyPublisher<CLAuthorizationStatus, Never> {
    return authorizationSubject.eraseToAnyPublisher()
  }

  func requestLocationPermission() {
    locationManager.requestWhenInUseAuthorization()
  }

  func startTrackingLocation() {
    locationManager.startUpdatingLocation()
  }

  func stopTrackingLocation() {
    locationManager.stopUpdatingLocation()
  }
}

extension LocationManager: CLLocationManagerDelegate {
  func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    locationSubject.send(locations.last)
  }

  func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
    authorizationSubject.send(manager.authorizationStatus)
  }

  func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
    locationSubject.send(nil)
    MusculosLogger.logError(error, message: "Location manager failed with error", category: .locationManager)
  }
}

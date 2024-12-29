//
//  MapView.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import SwiftUI
import MapKit
import CoreLocation
import Utility

public struct MapLocationView: UIViewRepresentable {
  @Binding var locations: [CLLocationCoordinate2D]
  @Binding var isTracking: Bool

  let mapView = MKMapView()

  public init(locations: Binding<[CLLocationCoordinate2D]>, isTracking: Binding<Bool>) {
    self._locations = locations
    self._isTracking = isTracking
  }

  public func makeUIView(context: Context) -> some UIView {
    mapView.delegate = context.coordinator
    mapView.showsUserLocation = true
    return mapView
  }

  public func updateUIView(_ uiView: UIViewType, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(self)
  }
}

extension MapLocationView {
  public class Coordinator: NSObject, @preconcurrency CLLocationManagerDelegate, MKMapViewDelegate, @unchecked Sendable {
    private enum LocationError: Error {
      case authorizationDenied
    }

    var parent: MapLocationView
    var locationManager: CLLocationManager
    var locations: [CLLocationCoordinate2D]
    var isTracking: Bool

    init(_ parent: MapLocationView) {
      self.parent = parent
      self.locations = parent.locations
      self.isTracking = parent.isTracking
      self.locationManager = CLLocationManager()

      super.init()

      self.locationManager.delegate = self
      checkAuthorizationStatus()
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard isTracking, let newLocation = locations.last else {
        return
      }

      self.locations.append(newLocation.coordinate)
      updatePolyline()
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
        locationManager.startUpdatingLocation()
        setupInitialRegion()
      @unknown default:
        Logger.warning(message: "Unknown authorization status")
      }
    }

    public func setupInitialRegion() {
      guard let initialLocation = locationManager.location?.coordinate else {
        Logger.warning(message: "Cannot get initial location")
        return
      }

      let zoomLevel: CLLocationDistance = 0.01
      let region = MKCoordinateRegion(
        center: initialLocation,
        span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel)
      )

      parent.mapView.setRegion(region, animated: true)
    }

    public func updatePolyline() {
      let polyline = MKPolyline(coordinates: locations, count: locations.count)
      parent.mapView.removeOverlays(parent.mapView.overlays)
      parent.mapView.addOverlay(polyline)

      if let lastLocation = locations.last {
        let region = MKCoordinateRegion(center: lastLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        parent.mapView.setRegion(region, animated: true)
      }
    }
  }
}

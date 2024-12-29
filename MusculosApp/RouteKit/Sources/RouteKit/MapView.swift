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
    private var locationsTask: Task<Void, Never>?

    var parent: MapLocationView
    var locationManager: LocationManager

    init(_ parent: MapLocationView) {
      self.parent = parent
      self.locationManager = LocationManager()

      super.init()

      locationManager.checkAuthorizationStatus()
      startListeningForLocationUpdates()
    }

    deinit {
      locationsTask?.cancel()
    }

    private func startListeningForLocationUpdates() {
      locationsTask?.cancel()

      locationsTask = Task { [weak self] in
        guard let self else {
          return
        }

        for await location in locationManager.locationStream {
          updateMapLocation(location)
        }
      }
    }

    private func updateMapLocation(_ location: CLLocation) {
      let zoomLevel: CLLocationDistance = 0.01
      let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
      parent.mapView.setRegion(region, animated: true)
    }

    public func updatePolyline(_ locations: [CLLocationCoordinate2D]) {
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

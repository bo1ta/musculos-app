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
  @Binding var averagePace: Double

  public func makeUIView(context: Context) -> MKMapView {
    context.coordinator.mapView
  }

  public func updateUIView(_ uiView: MKMapView, context: Context) {}

  public func makeCoordinator() -> Coordinator {
    Coordinator(averagePace: $averagePace)
  }

  public static func dismantleUIView(_ uiView: MKMapView, coordinator: Coordinator) {
    coordinator.stopListeningForLocationUpdates()
  }
}

extension MapLocationView {
  public class Coordinator: NSObject, @preconcurrency CLLocationManagerDelegate, MKMapViewDelegate, @unchecked Sendable {
    private var averagePace: Binding<Double>
    private var locationsTask: Task<Void, Never>?
    private let locationManager: LocationManager
    private var totalDistance: CLLocationDistance = 0.0
    private var startTime: Date?
    private var lastLocation: CLLocation?

    public lazy var mapView: MKMapView = {
      let mapView = MKMapView()
      mapView.delegate = self
      mapView.showsUserLocation = true
      return mapView
    }()

    init(averagePace: Binding<Double>) {
      self.averagePace = averagePace
      self.locationManager = LocationManager()

      super.init()

      locationManager.checkAuthorizationStatus()
      startListeningForLocationUpdates()
    }

    func startListeningForLocationUpdates() {
      locationsTask?.cancel()
      locationsTask = Task { [weak self] in
        guard let self else {
          return
        }

        startTime = Date()

        for await location in locationManager.locationStream {
          updateMapLocation(location)

          await MainActor.run {
            averagePace = .constant(calculateAveragePace(from: location))
          }

          lastLocation = location
        }
      }
    }

    private func calculateAveragePace(from location: CLLocation) -> Double {
      guard let lastLocation, let startTime else {
        return 0.0
      }

      totalDistance += location.distance(from: lastLocation)

      let elapsedTime = location.timestamp.timeIntervalSince(startTime)
      let elapsedTimeMinutes = elapsedTime / 60.0

      guard totalDistance > 0 else {
        return 0.0
      }

      let averagePace = elapsedTimeMinutes / (totalDistance / 1000.0)
      Logger.info(message: "Average pace: \(String(format: "%.2f min/km", averagePace))")
      return averagePace
    }

    func stopListeningForLocationUpdates() {
      locationsTask?.cancel()
      locationManager.closeLocationStream()
    }

    private func updateMapLocation(_ location: CLLocation) {
      let zoomLevel: CLLocationDistance = 0.01
      let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
      mapView.setRegion(region, animated: true)
    }

    public func updatePolyline(_ locations: [CLLocationCoordinate2D]) {
      let polyline = MKPolyline(coordinates: locations, count: locations.count)
      mapView.removeOverlays(mapView.overlays)
      mapView.addOverlay(polyline)

      if let lastLocation = locations.last {
        let region = MKCoordinateRegion(center: lastLocation, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        mapView.setRegion(region, animated: true)
      }
    }
  }
}

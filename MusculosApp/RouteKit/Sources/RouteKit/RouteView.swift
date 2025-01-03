//
//  MapView.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import CoreLocation
import MapKit
import SwiftUI
import Utility

// MARK: - RouteView

public struct RouteView: UIViewRepresentable {
  @Binding var currentLocation: CLLocation?
  @Binding var averagePace: Double

  init(currentLocation: Binding<CLLocation?> = .constant(nil), averagePace: Binding<Double>) {
    _currentLocation = currentLocation
    _averagePace = averagePace
  }

  public func makeUIView(context: Context) -> MKMapView {
    context.coordinator.mapView
  }

  public func updateUIView(_: MKMapView, context _: Context) { }

  public func makeCoordinator() -> Coordinator {
    Coordinator(averagePace: $averagePace, currentLocation: $currentLocation)
  }

  public static func dismantleUIView(_: MKMapView, coordinator: Coordinator) {
    coordinator.stopListeningForLocationUpdates()
  }
}

// MARK: RouteView.Coordinator

extension RouteView {
  public class Coordinator: NSObject, MKMapViewDelegate, @unchecked Sendable {
    private var averagePace: Binding<Double>
    private var currentLocation: Binding<CLLocation?>

    private let locationManager: LocationManager
    private var totalDistance: CLLocationDistance = 0.0
    private var startTime: Date?
    private var locationsTask: Task<Void, Never>?
    private var pinnedLocations: [CLLocationCoordinate2D] = []

    public lazy var mapView: MKMapView = {
      let mapView = MKMapView()
      mapView.delegate = self
      mapView.showsUserLocation = true
      return mapView
    }()

    init(averagePace: Binding<Double>, currentLocation: Binding<CLLocation?>) {
      self.averagePace = averagePace
      self.currentLocation = currentLocation
      locationManager = LocationManager()

      super.init()

      locationManager.checkAuthorizationStatus()
      startListeningForLocationUpdates()
      setupGestureRecognizer()
    }

    private func setupGestureRecognizer() {
      let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
      longPressGesture.minimumPressDuration = 0.5
      mapView.addGestureRecognizer(longPressGesture)
    }

    @objc
    private func handleLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
      guard gestureRecognizer.state == .began else {
        return
      }

      let touchPoint = gestureRecognizer.location(in: mapView)
      let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
      addMarker(at: coordinate)
    }

    private func addMarker(at coordinate: CLLocationCoordinate2D) {
      let annotation = MKPointAnnotation()
      annotation.coordinate = coordinate
      annotation.title = "Custom Pin"
      annotation.subtitle = "Long press to add another pin"
      mapView.addAnnotation(annotation)
      pinnedLocations.append(coordinate)
      updatePolyline(pinnedLocations)
    }

    func startListeningForLocationUpdates() {
      locationsTask?.cancel()
      locationsTask = Task { [weak self] in
        guard let self else {
          return
        }

        startTime = Date()

        for await location in locationManager.locationStream {
          await MainActor.run {
            updateMapLocation(location)
            averagePace.wrappedValue = calculateAveragePace(from: location)
            currentLocation.wrappedValue = location
          }
        }
      }
    }

    private func calculateAveragePace(from location: CLLocation) -> Double {
      guard let lastLocation = currentLocation.wrappedValue, let startTime else {
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
      let region = MKCoordinateRegion(
        center: location.coordinate,
        span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
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

    // MARK: - MKMapViewDelegate

    public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
      guard !annotation.isKind(of: MKUserLocation.self) else {
        return nil
      }

      let identifier = "CustomPin"
      var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)

      if annotationView == nil {
        annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        annotationView?.canShowCallout = true

        // Customize pin appearance
        if let markerView = annotationView as? MKMarkerAnnotationView {
          markerView.markerTintColor = .systemPurple
          markerView.glyphImage = UIImage(systemName: "mappin")
        }
      } else {
        annotationView?.annotation = annotation
      }

      return annotationView
    }
  }
}

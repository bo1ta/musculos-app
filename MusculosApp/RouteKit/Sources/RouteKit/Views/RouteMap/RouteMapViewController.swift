//
//  RouteMapViewController.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import CoreLocation
import MapKit
import UIKit
import Utility

// MARK: - RouteMapViewController

public final class RouteMapViewController: UIViewController {
  private let locationManager = LocationManager()
  private let mapView = MKMapView()

  private var locationsTask: Task<Void, Never>?
  private var pinnedLocations: [CLLocationCoordinate2D] = []
  private var totalDistance: CLLocationDistance = 0
  private var startTime: Date?
  private var currentLocation: CLLocation?

  var onUpdatePace: ((Double) -> Void)?
  var onUpdateLocation: ((CLLocation?) -> Void)?
  var mapItemResults: [MapItemResult] = [] {
    didSet {
      updateMapWithResults(mapItemResults)
    }
  }

  override public func viewDidLoad() {
    super.viewDidLoad()

    setupMapView()
    setupGestureRecognizer()
    startListeningForLocationUpdates()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    stopListeningForLocationUpdates()

    super.viewWillDisappear(animated)
  }

  private func setupMapView() {
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(mapView)

    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])
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

  func updateMapWithResults(_ mapResults: [MapItemResult]) {
    guard !mapResults.isEmpty else {
      return
    }

    for result in mapResults {
      addMarker(at: result.placemark.coordinate, with: result.name)
      Logger.info(message: "Added map placemark from results")
    }
  }

  private func addMarker(at coordinate: CLLocationCoordinate2D, with title: String? = nil) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = title ?? "Custom Pin"
    annotation.subtitle = "Long press to add another pin"
    mapView.addAnnotation(annotation)

    pinnedLocations.append(coordinate)
    updatePolyline(pinnedLocations)
  }

  private func startListeningForLocationUpdates() {
    locationsTask?.cancel()
    locationsTask = Task { [weak self] in
      guard let self else {
        return
      }

      startTime = Date()

      for await location in locationManager.locationStream {
        await MainActor.run {
          updateMapLocation(location)
          onUpdatePace?(calculateAveragePace(from: location))
          onUpdateLocation?(location)
        }
      }
    }
  }

  private func calculateAveragePace(from location: CLLocation) -> Double {
    guard let lastLocation = currentLocation, let startTime else {
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
}

// MARK: MKMapViewDelegate

extension RouteMapViewController: MKMapViewDelegate {
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

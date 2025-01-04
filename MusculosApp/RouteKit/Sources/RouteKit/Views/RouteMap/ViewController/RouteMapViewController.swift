//
//  RouteMapViewController.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Combine
import CoreLocation
import MapKit
import UIKit
import Utility

// MARK: - RouteMapViewController

public final class RouteMapViewController: UIViewController {
  private let locationManager = LocationManager()
  private let mapView = MKMapView()

  private var cancellables: Set<AnyCancellable> = []
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

  // MARK: Lifecycle

  override public func viewDidLoad() {
    super.viewDidLoad()

    setupMapView()
    setupLocationObservers()
  }

  override public func viewWillDisappear(_ animated: Bool) {
    locationManager.stopTracking()

    super.viewWillDisappear(animated)
  }

  // MARK: Setup

  private func setupMapView() {
    mapView.register(MarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: MarkerAnnotationView.reuseIdentifier)
    mapView.register(UserLocationAnnotationView.self, forAnnotationViewWithReuseIdentifier: UserLocationAnnotationView.identifier)

    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
    longPressGesture.minimumPressDuration = 0.5

    mapView.addGestureRecognizer(longPressGesture)
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

  @objc
  private func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    guard gestureRecognizer.state == .began else {
      return
    }

    let touchPoint = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
    addMarker(at: coordinate)
  }

  private func setupLocationObservers() {
    locationManager.currentLocationPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] location in
        self?.locationDidUpdate(location)
      }
      .store(in: &cancellables)

    locationManager.locationHeadingPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] heading in
        self?.locationHeadingDidUpdate(heading)
      }
      .store(in: &cancellables)
  }
}

// MARK: - Location Observing

extension RouteMapViewController {
  private func locationDidUpdate(_ location: CLLocation?) {
    guard let location else {
      return
    }

    currentLocation = location
    updateMapLocation(location)
    onUpdatePace?(calculateAveragePace(from: location))
    onUpdateLocation?(location)
  }

  private func locationHeadingDidUpdate(_ heading: CLHeading) {
    guard heading.headingAccuracy > 0 else {
      return
    }

    let headingAngle = CGFloat(heading.trueHeading * .pi / 100)

    if let userLocationView = mapView.view(for: mapView.userLocation) as? UserLocationAnnotationView {
      userLocationView.transform = CGAffineTransform(rotationAngle: headingAngle)
    }
  }
}

// MARK: - MapView handlers

extension RouteMapViewController {
  private func updateMapLocation(_ location: CLLocation) {
    let zoomLevel: CLLocationDistance = 0.01
    let region = MKCoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
    mapView.setRegion(region, animated: true)
  }

  private func addMarker(at coordinate: CLLocationCoordinate2D, with title: String? = nil) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = title ?? "Custom Pin"
    annotation.subtitle = "Long press to add another pin"
    mapView.addAnnotation(annotation)
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

  private func updateMapWithResults(_ mapResults: [MapItemResult]) {
    guard !mapResults.isEmpty else {
      return
    }

    mapView.removeAnnotations(mapView.annotations)

    for result in mapResults {
      addMarker(at: result.placemark.coordinate, with: result.name)
      Logger.info(message: "Added map placemark from results")
    }
  }

  private func findCategoryForCoordinate(_ coordinate: CLLocationCoordinate2D) -> MapItemResult.Category? {
    mapItemResults
      .first(where: {
        $0.placemark.coordinate.latitude == coordinate.latitude && $0.placemark.coordinate.longitude == coordinate.longitude
      })?
      .category
  }
}

// MARK: MKMapViewDelegate

extension RouteMapViewController: MKMapViewDelegate {
  public func mapView(_ mapView: MKMapView, viewFor annotation: any MKAnnotation) -> MKAnnotationView? {
    switch annotation {
    case is MKUserLocation:
      if let view = mapView.dequeueReusableAnnotationView(withIdentifier: UserLocationAnnotationView.identifier) {
        view.annotation = annotation
        return view
      } else {
        return UserLocationAnnotationView(annotation: annotation, reuseIdentifier: UserLocationAnnotationView.identifier)
      }

    default:
      if
        let annotationView = mapView
          .dequeueReusableAnnotationView(withIdentifier: MarkerAnnotationView.reuseIdentifier) as? MarkerAnnotationView
      {
        annotationView.annotation = annotation
        if let category = findCategoryForCoordinate(annotation.coordinate) {
          annotationView.configure(for: category)
        }
        return annotationView
      } else {
        let annotationView = MarkerAnnotationView(annotation: annotation, reuseIdentifier: MarkerAnnotationView.reuseIdentifier)
        if let category = findCategoryForCoordinate(annotation.coordinate) {
          annotationView.configure(for: category)
        }
        return annotationView
      }
    }
  }
}

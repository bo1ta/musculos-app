//
//  RouteMapViewController.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Combine
import CoreLocation
import Factory
import MapKit
import UIKit
import Utility

// MARK: - RouteMapViewController

public final class RouteMapViewController: UIViewController {
  @LazyInjected(\RouteKitContainer.locationManager) private var locationManager: LocationManager

  private var cancellables: Set<AnyCancellable> = []
  private var totalDistance: CLLocationDistance = 0
  private var startTime: Date?
  private var routeOverlay: MKPolyline?

  private var currentLocation: CLLocation? {
    didSet {
      if let currentLocation {
        updateMapLocation(currentLocation)
      }
    }
  }

  private lazy var mapView: MKMapView = {
    let mapView = MKMapView()
    mapView.delegate = self
    mapView.showsUserLocation = true
    mapView.translatesAutoresizingMaskIntoConstraints = false
    mapView.overrideUserInterfaceStyle = .dark
    mapView.userTrackingMode = .followWithHeading

    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(didLongPress(_:)))
    longPressGesture.minimumPressDuration = 0.5
    mapView.addGestureRecognizer(longPressGesture)

    return mapView
  }()

  var onUpdatePace: ((Double) -> Void)?
  var onUpdateLocation: ((CLLocation?) -> Void)?

  var mapItemResults: [MapItemData] = [] {
    didSet {
      updateMapWithResults(mapItemResults)
    }
  }

  var currentRoute: MKRoute? {
    didSet {
      if let currentRoute {
        updateMapWithRoute(currentRoute)
      } else {
        removeRouteOverlay()
      }
    }
  }

  var zoomLevel: CLLocationDistance = 0.01 {
    didSet {
      guard let currentLocation else {
        return
      }
      updateMapLocation(currentLocation, withZoomLevel: zoomLevel)
      updateUserAnnotationSize()
    }
  }

  private func updateUserAnnotationSize() {
    guard let userAnnotationView = mapView.annotations.first(where: { $0 is MKUserLocation }) as? UserLocationAnnotationView else {
      return
    }
    userAnnotationView.updateArrowSize(15)
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

    view.addSubview(mapView)

    NSLayoutConstraint.activate([
      mapView.topAnchor.constraint(equalTo: view.topAnchor),
      mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
    ])

    if let userLocation = mapView.userLocation.location?.coordinate {
      let mapCamera = mapView.camera
      mapCamera.centerCoordinate = userLocation
      mapCamera.centerCoordinateDistance = 500
      mapCamera.pitch = 60
      mapCamera.heading = 0
    }
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

    locationManager.errorPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] error in
        self?.locationDidFailWithError(error)
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

    onUpdatePace?(calculateAveragePace(from: location))
    onUpdateLocation?(location)

    currentLocation = location
  }

  private func locationHeadingDidUpdate(_ heading: CLHeading) {
    guard heading.headingAccuracy > 0 else {
      return
    }

    let headingAngle = CGFloat(heading.trueHeading * .pi / 100)
    mapView.camera.heading = headingAngle

    if let userLocationView = mapView.view(for: mapView.userLocation) as? UserLocationAnnotationView {
      userLocationView.transform = CGAffineTransform(rotationAngle: headingAngle)
    }
  }

  private func locationDidFailWithError(_ error: Error) {
    switch error {
    case LocationManager.LocationError.authorizationDenied:
      showPermissionsDeniedAlert()
    default:
      // do nothing for now, since the error is already logged by the locationManager
      break
    }
  }

  private func showPermissionsDeniedAlert() {
    let alert = UIAlertController(
      title: "This device has restricted access to your location.",
      message: "Open Settings to change access.",
      preferredStyle: .alert)

    let okAction = UIAlertAction(title: "OK", style: .cancel)
    alert.addAction(okAction)

    let openSettingsHandler: (UIAlertAction) -> Void = { _ in
      guard
        let url = URL(string: UIApplication.openSettingsURLString),
        UIApplication.shared.canOpenURL(url)
      else {
        Logger.error(MusculosError.unknownError, message: "Could not open settings")
        return
      }

      UIApplication.shared.open(url)
    }
    let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: openSettingsHandler)
    alert.addAction(settingsAction)

    self.presentedViewController?.present(alert, animated: true)
  }
}

// MARK: - MapView handlers

extension RouteMapViewController {
  @objc
  private func didLongPress(_ gestureRecognizer: UILongPressGestureRecognizer) {
    guard gestureRecognizer.state == .began else {
      return
    }

    let touchPoint = gestureRecognizer.location(in: mapView)
    let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
    addMarker(at: coordinate)
  }

  /// Re-center the map to the passed location
  ///
  private func updateMapLocation(_ location: CLLocation, withZoomLevel zoomLevel: CLLocationDistance = 0.01) {
    let region = MKCoordinateRegion(
      center: location.coordinate,
      span: MKCoordinateSpan(latitudeDelta: zoomLevel, longitudeDelta: zoomLevel))
    mapView.setRegion(region, animated: true)
    mapView.camera.centerCoordinate = location.coordinate
  }

  private func addMarker(at coordinate: CLLocationCoordinate2D, with title: String? = nil) {
    let annotation = MKPointAnnotation()
    annotation.coordinate = coordinate
    annotation.title = title ?? "Custom Pin"
    annotation.subtitle = "Long press to add another pin"
    mapView.addAnnotation(annotation)
  }

  /// Calculates the average pace by comparing the new location to the previous location
  /// where Pace = Time / Distance
  /// Returns the Double representation in min/km format
  ///
  private func calculateAveragePace(from location: CLLocation) -> Double {
    guard let lastLocation = currentLocation, let startTime else {
      return 0.0
    }

    totalDistance += location.distance(from: lastLocation)

    guard totalDistance > 0 else {
      return 0.0
    }

    let elapsedMinutes = location.timestamp.timeIntervalSince(startTime) / 60
    let averagePace = elapsedMinutes / totalDistance.inKilometers()
    Logger.info(message: "Average pace: \(String(format: "%.2f min/km", averagePace))")
    return averagePace
  }

  private func updateMapWithRoute(_ route: MKRoute) {
    removeRouteOverlay()
    routeOverlay = route.polyline

    if let routeOverlay {
      mapView.addOverlay(routeOverlay, level: .aboveRoads)

      let routeRect = routeOverlay.boundingMapRect
      let padding: CGFloat = 100.0
      let paddedRect = routeRect.insetBy(dx: -padding, dy: -padding)
      mapView.setVisibleMapRect(paddedRect, edgePadding: UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding), animated: true)
    }
  }

  private func removeRouteOverlay() {
    guard let routeOverlay else {
      return
    }
    mapView.removeOverlay(routeOverlay)
    self.routeOverlay = nil
  }

  /// Populates the map with marker annotations for the given results
  ///
  private func updateMapWithResults(_ mapResults: [MapItemData]) {
    guard !mapResults.isEmpty else {
      return
    }

    mapView.removeAnnotations(mapView.annotations)

    for result in mapResults {
      addMarker(at: result.placemark.coordinate, with: result.name)
      Logger.info(message: "Added map placemark from results")
    }
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
        if let category = findCategoryForAnnotation(annotation) {
          annotationView.configure(for: category)
        }
        return annotationView
      } else {
        let annotationView = MarkerAnnotationView(annotation: annotation, reuseIdentifier: MarkerAnnotationView.reuseIdentifier)
        if let category = findCategoryForAnnotation(annotation) {
          annotationView.configure(for: category)
        }
        return annotationView
      }
    }
  }

  public func mapView(_: MKMapView, rendererFor overlay: any MKOverlay) -> MKOverlayRenderer {
    let renderer = MKPolylineRenderer(overlay: overlay)
    renderer.strokeColor = .green
    renderer.lineCap = .round
    renderer.lineWidth = 3.0
    return renderer
  }

  /// Pulls the result category for the given coordinates.
  /// This should never return a nil value since the passed annotation was created populated at some point from the `mapItemResults`
  ///
  private func findCategoryForAnnotation(_ annotation: MKAnnotation) -> MapItemData.Category? {
    mapItemResults.first(where: {
      $0.placemark.coordinate.latitude == annotation.coordinate.latitude &&
        $0.placemark.coordinate.longitude == annotation.coordinate.longitude
    })?.category
  }
}

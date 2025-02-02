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

public struct RouteMap: UIViewControllerRepresentable {
  @Binding var currentLocation: CLLocation?
  @Binding var averagePace: Double
  @Binding var mapItemResults: [MapItemData]
  @Binding var currentRoute: MKRoute?
  @Binding var zoomLevel: CLLocationDistance
  @Binding var mapCameraType: MapCameraType

  init(
    currentLocation: Binding<CLLocation?> = .constant(nil),
    averagePace: Binding<Double>,
    mapItemResults: Binding<[MapItemData]> = .constant([]),
    currentRoute: Binding<MKRoute?> = .constant(nil),
    zoomLevel: Binding<CLLocationDistance> = .constant(0.01),
    mapCameraType: Binding<MapCameraType> = .constant(.planning))
  {
    _currentLocation = currentLocation
    _averagePace = averagePace
    _mapItemResults = mapItemResults
    _currentRoute = currentRoute
    _zoomLevel = zoomLevel
    _mapCameraType = mapCameraType
  }

  public func makeUIViewController(context _: Context) -> RouteMapViewController {
    let viewController = RouteMapViewController()
    viewController.onUpdatePace = { averagePace = $0 }
    viewController.onUpdateLocation = { currentLocation = $0 }
    return viewController
  }

  public func updateUIViewController(_ uiViewController: RouteMapViewController, context _: Context) {
    uiViewController.mapItemResults = mapItemResults
    uiViewController.currentRoute = currentRoute
    uiViewController.zoomLevel = zoomLevel
    uiViewController.mapCameraType = mapCameraType
  }
}

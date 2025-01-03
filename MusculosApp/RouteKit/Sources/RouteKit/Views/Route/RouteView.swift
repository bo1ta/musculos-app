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

public struct RouteView: UIViewControllerRepresentable {
  @Binding var currentLocation: CLLocation?
  @Binding var averagePace: Double
  @Binding var mapItemResults: [MapItemResult]

  init(currentLocation: Binding<CLLocation?> = .constant(nil), averagePace: Binding<Double>, mapItemResults: Binding<[MapItemResult]> = .constant([])) {
    _currentLocation = currentLocation
    _averagePace = averagePace
    _mapItemResults = mapItemResults
  }

  public func makeUIViewController(context: Context) -> RouteViewController {
      let viewController = RouteViewController()
      viewController.onUpdatePace = { averagePace = $0 }
      viewController.onUpdateLocation = { currentLocation = $0 }
      return viewController
  }

  public func updateUIViewController(_ uiViewController: RouteViewController, context: Context) {
      uiViewController.mapItemResults = mapItemResults
  }
}

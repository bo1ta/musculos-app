//
//  MapItemResult.swift
//  RouteKit
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import Foundation
import MapKit

public struct MapItemResult: Sendable {
  var identifier: UUID
  var name: String
  var placemark: MKPlacemark
  var pointOfInterestCategory: MKPointOfInterestCategory?
  var isCurrentLocation: Bool
}

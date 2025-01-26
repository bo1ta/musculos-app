//
//  CLLocationCoordinate2D+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import CoreLocation

extension CLLocationCoordinate2D {
  public func toCLLocation() -> CLLocation {
    CLLocation(latitude: latitude, longitude: longitude)
  }
}

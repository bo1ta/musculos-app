//
//  CLLocationDistance+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 04.01.2025.
//

import CoreLocation

extension CLLocationDistance {
  public func inKilometers() -> Double {
    self / 1000
  }
}

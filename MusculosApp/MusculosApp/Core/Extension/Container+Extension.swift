//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.11.2024.
//

import Factory

extension Container {
  var locationManager: Factory<LocationManagerProtocol> {
    self { LocationManager() }
      .shared
  }
}

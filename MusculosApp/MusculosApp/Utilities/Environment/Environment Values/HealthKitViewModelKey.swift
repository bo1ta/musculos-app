//
//  HealthKitViewModelKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  var healthKitViewModel: HealthKitViewModel {
    get { self[HealthKitViewModelKey.self] }
    set { self[HealthKitViewModelKey.self] = newValue }
  }
}

private struct HealthKitViewModelKey: EnvironmentKey {
  static var defaultValue: HealthKitViewModel = HealthKitViewModel()
}


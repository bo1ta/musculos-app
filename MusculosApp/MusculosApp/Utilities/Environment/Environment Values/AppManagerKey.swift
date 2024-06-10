//
//  AppManagerKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  var appManager: AppManager {
    get { self[AppManagerKey.self] }
    set { self[AppManagerKey.self] = newValue }
  }
}

private struct AppManagerKey: EnvironmentKey {
  static var defaultValue: AppManager = AppManager()
}

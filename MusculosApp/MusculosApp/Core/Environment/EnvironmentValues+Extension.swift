//
//  EnvironmentValues+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  var mainWindowSize: CGSize {
    get { self[MainWndowSizeKey.self] }
    set { self[MainWndowSizeKey.self] = newValue }
  }
  
  var customTabBarHidden: Bool {
    get { self[TabBarHidden.self] }
    set { self[TabBarHidden.self] = newValue }
  }
}

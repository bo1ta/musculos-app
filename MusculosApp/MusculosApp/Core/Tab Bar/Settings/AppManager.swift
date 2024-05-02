//
//  TabBarSettings.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import Foundation
import SwiftUI

class AppManager: ObservableObject {
  /// The observer for the tab bar visibility
  ///
  @Published var isTabBarHidden: Bool = false
  
  /// The observer for `Toast` view
  /// Set to show a useful toast message for success, info, error, warning states
  ///
  @Published var toast: Toast? = nil
}

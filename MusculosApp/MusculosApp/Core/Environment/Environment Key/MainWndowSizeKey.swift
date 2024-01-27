//
//  MainWndowSizeKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.10.2023.
//

import Foundation
import SwiftUI

struct MainWndowSizeKey: EnvironmentKey {
  static let defaultValue: CGSize = CGSize(width: 375, height: 667)
}

struct TabBarHidden: EnvironmentKey {
  static let defaultValue: Bool = false
}


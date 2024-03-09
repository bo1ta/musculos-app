//
//  Color+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

enum AppColorName: String {
  case mustardYellow = "MustardYellow"
  case spriteGreen   = "SpriteGreen"
  case violetBlue    = "VioletBlue"
  case background    = "Background"
  case grassGreen    = "GrassGreen"
  case navyBlue      = "NavyBlue"
  case customOrange  = "CustomOrange"
  case customRed     = "CustomRed"
  case lightGrey     = "LightGrey"
  case lightCyan     = "LightCyan"
}

extension Color {
  static func appColor(with name: AppColorName) -> Color {
    return Color(name.rawValue)
  }
}

//
//  Color+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import SwiftUI

enum AppColor: String {
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
  
  // MARK: - Primary colors
  
  case blue100 = "Blue100"
  case blue200 = "Blue200"
  case blue300 = "Blue300"
  case blue400 = "Blue400"
  case blue500 = "Blue500"
  case blue600 = "Blue600"
  case blue700 = "Blue700"
  case blue800 = "Blue800"
  case blue900 = "Blue900"
  
  case green100 = "Green100"
  case green200 = "Green200"
  case green300 = "Green300"
  case green400 = "Green400"
  case green500 = "Green500"
  case green600 = "Green600"
  case green700 = "Green700"
  case green800 = "Green800"
  
  var color: Color {
    Color(self.rawValue)
  }
}

extension Color {
  struct AppColor {
    struct Blue {
      static let blue100 = Color("Blue100")
    }
  }
}

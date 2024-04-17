//
//  AppFont.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import SwiftUI

struct AppFont {
  enum Header: String {
    case regular = "Epilogue-Regular"
    case medium = "Epilogue-Medium"
    case bold = "Epilogue-Bold"
  }
  
  enum Body: String {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"
    case light = "Inter-Light"
    case thin = "Inter-Thin"
  }
}

extension Font {
  static func header(_ headerType: AppFont.Header, size: CGFloat = 12.0) -> Font {
    return custom(headerType.rawValue, size: size)
  }
  
  static func body(_ bodyType: AppFont.Body, size: CGFloat = 12.0) -> Font {
    return custom(bodyType.rawValue, size: size)
  }
}

//
//  AppFont.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import SwiftUI

public struct AppFont {
  public enum Header: String {
    case regular = "Epilogue-Regular"
    case medium = "Epilogue-Medium"
    case bold = "Epilogue-Bold"
  }
  
  public enum Body: String {
    case regular = "Inter-Regular"
    case medium = "Inter-Medium"
    case semiBold = "Inter-SemiBold"
    case bold = "Inter-Bold"
    case light = "Inter-Light"
    case thin = "Inter-Thin"
  }
  
  public static func header(_ headerType: AppFont.Header, size: CGFloat = 12.0) -> Font {
    return Font.custom(headerType.rawValue, size: size)
  }
  
  public static func body(_ bodyType: AppFont.Body, size: CGFloat = 12.0) -> Font {
    return Font.custom(bodyType.rawValue, size: size)
  }
}

extension Font {
  public static func header(_ headerType: AppFont.Header, size: CGFloat = 12.0) -> Font {
    return AppFont.header(headerType, size: size)
  }
  
  public static func body(_ bodyType: AppFont.Body, size: CGFloat = 12.0) -> Font {
    return AppFont.body(bodyType, size: size)
  }
}

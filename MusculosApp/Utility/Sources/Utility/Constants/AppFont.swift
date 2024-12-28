//
//  AppFont.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import SwiftUI

public enum AppFont {
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

  public enum Poppins: String {
    case regular = "Poppins-Regular"
    case medium = "Poppins-Medium"
    case bold = "Poppins-Bold"
    case light = "Poppins-Light"
    case semibold = "Poppins-SemiBold"
  }

  public enum LeagueSpartan: String {
    case black = "LeagueSpartan-Black"
    case bold = "LeagueSpartan-Bold"
    case extraBold = "LeagueSpartan-ExtraBold"
    case extraLight = "LeagueSpartan-ExtraLight"
    case light = "LeagueSpartan-Light"
    case medium = "LeagueSpartan-Medium"
    case regular = "LeagueSpartan-Regular"
    case semiBold = "LeagueSpartan-SemiBold"
  }

  public static func header(_ headerType: AppFont.Header, size: CGFloat = 12.0) -> Font {
    return Font.custom(headerType.rawValue, size: size)
  }

  public static func body(_ bodyType: AppFont.Body, size: CGFloat = 12.0) -> Font {
    return Font.custom(bodyType.rawValue, size: size)
  }

  public static func poppins(_ type: Poppins, size: CGFloat = 14.0) -> Font {
    return Font.custom(type.rawValue, size: size)
  }

  public static func spartan(_ type: LeagueSpartan, size: CGFloat = 14.0) -> Font {
    return Font.custom(type.rawValue, size: size)
  }
}

public extension Font {
  static func header(_ headerType: AppFont.Header, size: CGFloat = 12.0) -> Font {
    return AppFont.header(headerType, size: size)
  }

  static func body(_ bodyType: AppFont.Body, size: CGFloat = 12.0) -> Font {
    return AppFont.body(bodyType, size: size)
  }
}

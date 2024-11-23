//
//  Toast.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

public struct Toast: Equatable, Sendable {
  public var style: ToastStyle
  public var message: String
  public var duration: Double
  public var width: Double

  public init(style: ToastStyle, message: String, duration: Double = 1.5, width: Double = .infinity) {
    self.style = style
    self.message = message
    self.duration = duration
    self.width = width
  }
}

// MARK: - Toast Style

public extension Toast {
  enum ToastStyle: Sendable {
    case success, info, warning, error
    
    var borderColor: Color {
      switch self {
      case .success: Color.AppColor.green700
      case .info: Color.AppColor.blue500
      case .warning: Color.orange
      case .error: Color.red
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .success: Color.AppColor.green100
      case .info: Color.gray
      case .warning: Color.yellow
      case .error: Color.red
      }
    }
    
    var systemImageName: String {
      switch self {
      case .success: "checkmark.circle.fill"
      case .info: "info.circle.fill"
      case .warning: "exclamationmark.triangle.fill"
      case .error: "xmark.circle.fill"
      }
    }
  }
}

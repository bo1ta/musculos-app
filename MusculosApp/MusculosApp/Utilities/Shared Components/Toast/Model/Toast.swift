//
//  Toast.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import SwiftUI

struct Toast: Equatable {
  var style: ToastStyle
  var message: String
  var duration: Double = 1
  var width: Double = .infinity
}

// MARK: - Toast Style

extension Toast {
  enum ToastStyle {
    case success, info, warning, error
    
    var borderColor: Color {
      switch self {
      case .success: Color.AppColor.blue300
      case .info: Color.AppColor.blue500
      case .warning: Color.orange
      case .error: Color.red
      }
    }
    
    var backgroundColor: Color {
      switch self {
      case .success: Color.AppColor.blue100
      case .info: Color.gray.opacity(0.1)
      case .warning: Color.yellow.opacity(0.1)
      case .error: Color.red.opacity(0.1)
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

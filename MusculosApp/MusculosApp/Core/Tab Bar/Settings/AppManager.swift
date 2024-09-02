//
//  TabBarSettings.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import Foundation
import SwiftUI
import Combine
import Components
import Utility

protocol AppManagerProtocol {
  
  /// Shows the app tab bar
  ///
  func showTabBar() async
  
  /// Hides the app tab bar
  ///
  func hideTabBar() async
  
  /// Shows a message toast for a given duration
  /// Params:
  ///  - `style`: Can be .success, .info, .error, .warning
  ///  - `message`: Message to be displayed
  ///  - `duration`: Duration of the toast
  ///
  func showToast(style: Toast.ToastStyle, message: String, duration: Double) async
  
  /// Notify a model update.
  /// Posts a notification for refreshing the data (if needed)
  /// 
  func notifyModelUpdate(_ event: ModelUpdatedEvent) async
}

/// Helper manager that is passed from the root level
///
@Observable
@MainActor
final class AppManager {
  private(set) var isTabBarHidden: Bool = false
  var toast: Toast? = nil
}

// MARK: - Functions

extension AppManager: AppManagerProtocol {
  
  func hideTabBar() {
    guard !isTabBarHidden else { return }
    isTabBarHidden = true
  }
  
  func showTabBar() {
    guard isTabBarHidden else { return }
    isTabBarHidden = false
  }
  
  func showToast(style: Toast.ToastStyle, message: String, duration: Double = 2.0) {
    toast = Toast(style: style, message: message, duration: duration)
  }
  
  func notifyModelUpdate(_ event: ModelUpdatedEvent) {
    NotificationCenter.default.post(name: .CoreDataModelDidChange, object: nil, userInfo: [ModelUpdatedEvent.userInfoKey: event])
  }
}


extension Notification.Name {
  static let CoreDataModelDidChange = Notification.Name("CoreModelDidChange")
}

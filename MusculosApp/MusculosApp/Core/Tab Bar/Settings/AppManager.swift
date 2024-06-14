//
//  TabBarSettings.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import Foundation
import SwiftUI
import Combine

protocol AppManagerProtocol {
  
  /// Shows the app tab bar
  ///
  func showTabBar()
  
  /// Hides the app tab bar
  ///
  func hideTabBar()
  
  /// Shows a message toast for a given duration
  /// Params:
  ///  - `style`: Can be .success, .info, .error, .warning
  ///  - `message`: Message to be displayed
  ///  - `duration`: Duration of the toast
  ///
  func showToast(style: Toast.ToastStyle, message: String, duration: Double)
  
  /// Notify a model update.
  /// Posts a notification that for refreshing the data (if needed)
  /// 
  func notifyModelUpdate(_ event: ModelUpdatedEvent)
}

/// Helper manager that is passed from the root level
///
@Observable
final class AppManager {
  private(set) var isTabBarHidden: Bool = false
  var toast: Toast? = nil
}

// MARK: - Functions

extension AppManager: AppManagerProtocol {
  
  @MainActor
  func hideTabBar() {
    guard !isTabBarHidden else { return }
    isTabBarHidden = true
  }
  
  @MainActor
  func showTabBar() {
    guard isTabBarHidden else { return }
    isTabBarHidden = false
  }
  
  @MainActor
  func showToast(style: Toast.ToastStyle, message: String, duration: Double = 2.0) {
    toast = Toast(style: style, message: message, duration: duration)
  }
  
  @MainActor
  func notifyModelUpdate(_ event: ModelUpdatedEvent) {
    NotificationCenter.default.post(name: .CoreModelDidChange, object: nil, userInfo: [ModelUpdatedEvent.userInfoKey: event])
  }
}

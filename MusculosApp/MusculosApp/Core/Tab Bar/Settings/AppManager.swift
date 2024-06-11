//
//  TabBarSettings.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.01.2024.
//

import Foundation
import SwiftUI
import Combine


/// Helper manager that is passed from the root level
///
@Observable
final class AppManager {
  /// The observer for the tab bar visibility
  ///
  private(set) var isTabBarHidden: Bool = false
  
  /// The observer for `Toast` view
  /// Set to show a useful toast message for success, info, error, warning states
  ///
  var toast: Toast? = nil
  
  /// Publisher to notify changes to various models
  /// Subscribe to this to update the data if needed
  ///
  let didUpdateModelEvent = PassthroughSubject<ModelEvent, Never>()
  
  private(set) var dispatchTask: Task<Void, Never>?
}

// MARK: - Functions

extension AppManager {
  
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
  func dispatchEvent(for modelEvent: ModelEvent) {
    didUpdateModelEvent.send(modelEvent)
  }
}

extension AppManager {
  enum ModelEvent {
    case didAddGoal
    case didAddExerciseSession
    case didAddExercise
    case didFavoriteExercise
  }
}

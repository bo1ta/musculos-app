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
@MainActor
class AppManager: ObservableObject {
  /// The observer for the tab bar visibility
  ///
  @Published private(set) var isTabBarHidden: Bool = false
  
  /// The observer for `Toast` view
  /// Set to show a useful toast message for success, info, error, warning states
  ///
  @Published var toast: Toast? = nil
  
  /// Publisher to notify changes to various models
  /// Subscribe to this to update the data if needed
  ///
  let modelUpdateEvent = PassthroughSubject<ModelEvent, Never>()
}

// MARK: - Functions

extension AppManager {
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
  
  enum ModelEvent {
    case didAddGoal
    case didAddExerciseSession
    case didAddExercise
    case didFavoriteExercise
  }
  
  func dispatchEvent(for modelEvent: ModelEvent) {
    modelUpdateEvent.send(modelEvent)
  }
}


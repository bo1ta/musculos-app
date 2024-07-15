//
//  EnvironmentValues+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  
  var appManager: AppManager {
    get { self[AppManagerKey.self] }
    set { self[AppManagerKey.self] = newValue }
  }
  
  var userStore: UserStore {
    get { self[UserStoreKey.self] }
    set { self[UserStoreKey.self] = newValue }
  }
  
  var healthKitViewModel: HealthKitViewModel {
    get { self[HealthKitViewModelKey.self] }
    set { self[HealthKitViewModelKey.self] = newValue }
  }
  
}

// MARK: - AppManagerKey

private struct AppManagerKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: AppManager = AppManager()
}

// MARK: - UserStoreKey

private struct UserStoreKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: UserStore = UserStore()
}

// MARK: - HealthKitViewModelKey

private struct HealthKitViewModelKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: HealthKitViewModel = HealthKitViewModel()
}

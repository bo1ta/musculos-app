//
//  EnvironmentValues+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import SwiftUI
import Storage

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
  
  var navigationRouter: NavigationRouter {
    get { self[NavigationRouterKey.self] }
    set { self[NavigationRouterKey.self] = newValue}
  }

  var exerciseStore: StorageStore<ExerciseEntity> {
    get { self[ExerciseStoreKey.self] }
    set { self[ExerciseStoreKey.self] = newValue }
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

// MARK: - NavigationRouterKey

private struct NavigationRouterKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: NavigationRouter = NavigationRouter()
}

// MARK: - ExerciseStoreKey

private struct ExerciseStoreKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: StorageStore<ExerciseEntity> = StorageStore<ExerciseEntity>()
}


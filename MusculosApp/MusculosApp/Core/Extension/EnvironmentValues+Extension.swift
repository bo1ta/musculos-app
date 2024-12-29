//
//  EnvironmentValues+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import Storage
import SwiftUI

extension EnvironmentValues {
  var userStore: UserStore {
    get { self[UserStoreKey.self] }
    set { self[UserStoreKey.self] = newValue }
  }
}

// MARK: - UserStoreKey

private struct UserStoreKey: @preconcurrency EnvironmentKey {
  @MainActor static var defaultValue: UserStore = UserStore()
}

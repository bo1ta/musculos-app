//
//  UserStoreKey.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2024.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
  var userStore: UserStore {
    get { self[UserStoreKey.self] }
    set { self[UserStoreKey.self] = newValue }
  }
}

private struct UserStoreKey: EnvironmentKey {
  static var defaultValue: UserStore = UserStore()
}

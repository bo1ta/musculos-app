//
//  Container+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Components
import Factory
import Models

extension Container {
  var toastManager: Factory<ToastManagerProtocol> {
    self { ToastManager() }
      .cached
  }

  var userStore: Factory<UserStoreProtocol> {
    self { UserStore() }
      .cached
  }

  var goalStore: Factory<GoalStore> {
    self { GoalStore() }
      .cached
  }

  var soundManager: Factory<SoundManager> {
    self { SoundManager() }
      .singleton
  }
}

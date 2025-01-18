//
//  BaseViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.01.2025.
//

import Components
import Factory
import Models

// MARK: - BaseViewModel

/// Namespace that holds common operations used by view models
///
protocol BaseViewModel { }

extension BaseViewModel {
  var soundManager: SoundManager {
    Container.shared.soundManager()
  }

  var toastManager: ToastManagerProtocol {
    Container.shared.toastManager()
  }

  var userStore: UserStoreProtocol {
    Container.shared.userStore()
  }

  var currentUser: UserProfile? {
    userStore.currentUser
  }
}

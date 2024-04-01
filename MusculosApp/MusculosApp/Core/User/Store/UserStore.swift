//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI

class UserStore: ObservableObject, @unchecked Sendable {
  @Published var currentUserProfile: UserProfile? = nil
  @Published var error: Error? = nil
  @Published var isLoading: Bool = false
  @Published var isLoggedIn: Bool = false
  @Published var isOnboarded: Bool = false {
    didSet {
      DispatchQueue.main.async {
        UserDefaults.standard.setValue(self.isOnboarded, forKey: UserDefaultsKeyConstant.isOnboarded.rawValue)
      }
    }
  }
    
  private(set) var updateUserProfileTask: Task<Void, Never>?
  
  private let dataStore: UserDataStore
  
  init(dataStore: UserDataStore = UserDataStore()) {
    self.dataStore = dataStore
  }
  
  var displayName: String {
    currentUserProfile?.fullName ?? currentUserProfile?.username ?? "User"
  }
  
  @MainActor
  func initialLoad() {
    if let _ = UserDefaults.standard.string(forKey: UserDefaultsKeyConstant.authToken.rawValue) {
      self.isLoggedIn = true
    }
    
    let isOnboarded = UserDefaults.standard.bool(forKey: UserDefaultsKeyConstant.isOnboarded.rawValue)
    if isOnboarded {
      self.isOnboarded = true
    }
  }
  
  func cleanUp() {
    updateUserProfileTask?.cancel()
    updateUserProfileTask = nil
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) {
    updateUserProfileTask = Task { @MainActor [weak self] in
      guard let self else { return }
      _ = await self.dataStore.updateUserProfile(gender: gender, weight: weight, height: height, goalId: goalId)
    }
  }
}

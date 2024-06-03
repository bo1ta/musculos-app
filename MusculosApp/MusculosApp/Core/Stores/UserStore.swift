//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI

@MainActor
class UserStore: ObservableObject {
  @Published private(set) var currentPerson: Person? = nil
  @Published private(set) var error: Error? = nil
  @Published private(set) var isLoggedIn: Bool = false
  @Published private(set) var isOnboarded: Bool = false
    
  private(set) var updateUserTask: Task<Void, Never>?
  
  private let dataStore: UserDataStore
  
  init(dataStore: UserDataStore = UserDataStore()) {
    self.dataStore = dataStore
  }
  
  var displayName: String {
    currentPerson?.fullName ?? currentPerson?.username ?? "User"
  }

  @MainActor
  func initialLoad() async {
    if let _ = UserDefaults.standard.string(forKey: UserDefaultsKeyConstant.authToken.rawValue) {
      self.isLoggedIn = true
    }
    
    let isOnboarded = UserDefaults.standard.bool(forKey: UserDefaultsKeyConstant.isOnboarded.rawValue)
    if isOnboarded {
      self.isOnboarded = true
    }
    
    if let currentPerson = await dataStore.loadCurrentPerson() {
      self.currentPerson = currentPerson
    }
  }
  
  func cleanUp() {
    updateUserTask?.cancel()
    updateUserTask = nil
  }
  
  func setIsLoggedIn(_ isLoggedIn: Bool) {
    self.isLoggedIn = isLoggedIn
  }
  
  func setIsOnboarded(_ isOnboarded: Bool) {
    self.isOnboarded = isOnboarded
    UserDefaults.standard.setValue(isOnboarded, forKey: UserDefaultsKeyConstant.isOnboarded.rawValue)
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) {
    updateUserTask?.cancel()
    
    updateUserTask = Task.detached { [weak self] in
      guard let self else { return }
      
      do {
        try await self.dataStore.updateUser(gender: gender, weight: weight, height: height, goalId: goalId)
      } catch {
        MusculosLogger.logError(error, message: "Could not update user", category: .coreData)
      }
    }
  }
}

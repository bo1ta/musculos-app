//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine

@Observable
class UserStore {
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.userDataStore) private var dataStore: UserDataStoreProtocol
  
  @ObservationIgnored
  private(set) var refreshTask: Task<Void, Never>?
  
  // MARK: - Observed properties
  
  private(set) var currentUser: User? = nil
  private(set) var isLoggedIn: Bool = false
  private(set) var isLoading: Bool = false
  
  var displayName: String {
    return currentUser?.fullName
    ?? currentUser?.username
    ?? "User"
  }
  
  var isOnboarded: Bool {
    return currentUser?.isOnboarded ?? false
  }
  
  // MARK: - Setters
  
  func setIsLoggedIn(_ isLoggedIn: Bool) {
    self.isLoggedIn = isLoggedIn
  }
  
  // MARK: - Tasks

  @MainActor
  func initialLoad() async {
    isLoading = true
    defer { isLoading = false }
    
    if let _ = UserDefaults.standard.string(forKey: UserDefaultsKeyConstant.authToken.rawValue) {
      self.isLoggedIn = true
    }
    
    if let currentPerson = await dataStore.loadCurrentUser() {
      self.currentUser = currentPerson
    }
  }
  
  func refreshUser() {
    refreshTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.currentUser = await dataStore.loadCurrentUser()
    }
  }
}

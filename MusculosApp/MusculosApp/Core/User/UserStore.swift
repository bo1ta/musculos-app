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
import Models
import Storage

@Observable
@MainActor
class UserStore {
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.userDataStore) private var dataStore: UserDataStoreProtocol
  
  @ObservationIgnored
  private(set) var refreshTask: Task<Void, Never>?
  
  private(set) var userSession: UserSession? = nil
  
  // MARK: - Observed properties
  
  private(set) var currentUserProfile: UserProfile? = nil
  private(set) var isLoading: Bool = false
  
  var displayName: String {
    return currentUserProfile?.fullName
    ?? currentUserProfile?.username
    ?? "User"
  }
  
  var isOnboarded: Bool {
    return userSession?.isOnboarded ?? false
  }
  
  var isLoggedIn: Bool {
    return userSession != nil
  }
  
  // MARK: - Tasks

  func initialLoad() async {
    if let userSession = await UserSessionActor.shared.currentUser() {
      self.userSession = userSession
      
      if let currentProfile = await dataStore.loadProfile(userId: userSession.userId) {
        self.currentUserProfile = currentProfile
      }
    }
  }
  
  func refreshSession() {
    Task {
      if let userSession = await UserSessionActor.shared.currentUser() {
        self.userSession = userSession
      }
    }
  }
  
  func updateIsOnboarded(_ isOnboarded: Bool) {
    Task {
      await UserSessionActor.shared.updateSession(isOnboarded: isOnboarded)
      self.userSession = await UserSessionActor.shared.currentUser()
    }
  }
  
  func refreshUser() {
    guard let userSession else { return }
    refreshTask = Task {
      currentUserProfile = await dataStore.loadProfile(userId: userSession.userId)
    }
  }
}

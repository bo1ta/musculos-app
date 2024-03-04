//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI

class UserStore: ObservableObject {
  @Published var currentUserProfile: UserProfile? = nil
  @Published var error: Error? = nil
  @Published var isLoading: Bool = false
  @Published var isLoggedIn: Bool = false
  @Published var isOnboarded: Bool = false {
    didSet {
      DispatchQueue.main.async {
        UserDefaults.standard.setValue(self.isOnboarded, forKey: UserDefaultsKey.isOnboarded.rawValue)
      }
    }
  }
  
  private let module: UserModuleProtocol
  private let dataStore: UserDataStore
  
  private(set) var authTask: Task<Void, Never>?
  private(set) var fetchUserProfileTask: Task<Void, Never>?
  private(set) var updateUserProfileTask: Task<Void, Never>?
  
  init(module: UserModuleProtocol = UserModule(), dataStore: UserDataStore = UserDataStore()) {
    self.module = module
    self.dataStore = dataStore
  }
  
  var displayName: String {
    currentUserProfile?.fullName ?? currentUserProfile?.username ?? "champ"
  }
  
  @MainActor
  func initialLoad() {
    if let _ = UserDefaults.standard.string(forKey: UserDefaultsKey.authToken.rawValue) {
      self.isLoggedIn = true
    }
    
    let isOnboarded = UserDefaults.standard.bool(forKey: UserDefaultsKey.isOnboarded.rawValue)
    if isOnboarded {
      self.isOnboarded = true
    }
  }
  
  func cleanUp() {
    authTask?.cancel()
    authTask = nil
    
    fetchUserProfileTask?.cancel()
    fetchUserProfileTask = nil
  }
}

// MARK: - Networking

extension UserStore {
  func signIn(email: String, password: String) {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.error = nil
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let result = try await self.module.loginUser(email: email, password: password)
        
        UserDefaults.standard.setValue(result.token, forKey: UserDefaultsKey.authToken.rawValue)
        self.isLoggedIn = true
      } catch {
        self.error = error
        MusculosLogger.logError(error: error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  func signUp(person: Person, password: String) {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.error = nil
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let result = try await self.module
          .registerUser(email: person.email, password: password, username: person.username, fullName: person.fullName)
        await dataStore.createUserProfile(person: person)
        UserDefaults.standard.setValue(result.token, forKey: UserDefaultsKey.authToken.rawValue)
        self.isLoggedIn = true
      } catch {
        self.error = error
        MusculosLogger.logError(error: error, message: "Sign up failed", category: .networking)
      }
    }
  }
}

// MARK: - Core Data + User Defaults

extension UserStore {
  func fetchUserProfile() {
    fetchUserProfileTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.currentUserProfile = await UserProfile.currentUserProfile(context: CoreDataStack.shared.mainContext)
    }
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) {
    updateUserProfileTask = Task { @MainActor [weak self] in
      guard let self else { return }
      _ = await self.dataStore.updateUserProfile(gender: gender, weight: weight, height: height, goalId: goalId)
    }
  }
}
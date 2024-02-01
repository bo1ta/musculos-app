//
//  UserStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 31.01.2024.
//

import Foundation
import SwiftUI
import Supabase

class UserStore: ObservableObject {
  @Published var currentPerson: Person? = nil
  @Published var error: Error? = nil
  @Published var isLoading: Bool = false

  @Published var isLoggedIn: Bool = false {
    didSet {
      DispatchQueue.main.async {
        UserDefaultsWrapper.shared.setBool(value: self.isLoggedIn, key: UserDefaultsKey.isAuthenticated)
      }
    }
  }
  @Published var isOnboarded: Bool = false {
    didSet {
      DispatchQueue.main.async {
        UserDefaultsWrapper.shared.setBool(value: self.isOnboarded, key: UserDefaultsKey.isOnboarded)
      }
    }
  }
  
  private let module: UserModuleProtocol
  private(set) var authTask: Task<Void, Never>?
  
  init(module: UserModuleProtocol = UserModule()) {
    self.module = module
    self.isLoggedIn = UserDefaultsWrapper.shared.getBool(UserDefaultsKey.isAuthenticated)
    self.isOnboarded = UserDefaultsWrapper.shared.getBool(UserDefaultsKey.isOnboarded)
  }
  
  func signIn(email: String, password: String) {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.error = nil
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        try await self.module.loginUser(email: email, password: password)
        self.isLoggedIn = true
      } catch {
        self.error = error
        MusculosLogger.logError(error: error, message: "Sign in failed", category: .supabase)
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
        let extraData: [String: AnyJSON] = [
          "username": .string(person.username)
        ]
        try await self.module.registerUser(email: person.email, password: password, extraData: extraData)
        self.isLoggedIn = true
      } catch {
        self.error = error
        MusculosLogger.logError(error: error, message: "Sign up failed", category: .supabase)
      }
    }
  }
  
  func cancelTask() {
    authTask?.cancel()
  }
}

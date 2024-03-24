//
//  AuthViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var username: String = ""
  @Published var fullName: String = ""
  @Published var showRegister: Bool = false
  @Published var isLoading: Bool = false
  @Published var isLoggedIn: Bool = false
  @Published var errorMessage: String? = nil
  
  private(set) var authTask: Task<Void, Never>?
  
  private let module: Authenticatable
  private let dataStore: UserDataStore
  
  init(module: Authenticatable = AuthModule(), dataStore: UserDataStore = UserDataStore()) {
    self.module = module
    self.dataStore = dataStore
  }
  
  @MainActor
  func signIn() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let token = try await self.module.loginUser(email: self.email, password: self.password)
        await self.saveLocalUser(token)
        
        self.isLoggedIn = true
      } catch {
        self.errorMessage = "Unable to sign in. Please try again"
        MusculosLogger.logError(error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  @MainActor
  func signUp() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let token = try await self.module.registerUser(email: self.email,
                                                       password: self.password,
                                                       username: self.username,
                                                       fullName: self.fullName)
        await self.saveLocalUser(token)
        self.isLoggedIn = true
      } catch {
        self.errorMessage = "Unable to sign up. Please try again"
        MusculosLogger.logError(error, message: "Sign up failed", category: .networking)
      }
    }
  }
  
  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }
}

// MARK: Private helpers

extension AuthViewModel {
  private func saveLocalUser(_ token: String) async {
    let person = Person(email: self.email, fullName: self.fullName, username: self.username)
    await dataStore.createUserProfile(person: person)
    
    UserDefaults.standard.setValue(token, forKey: UserDefaultsKey.authToken.rawValue)
  }
}

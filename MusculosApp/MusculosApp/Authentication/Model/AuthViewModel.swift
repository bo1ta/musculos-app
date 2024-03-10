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
  @Published var state: LoadingViewState<String> = .empty("")
  
  private(set) var authTask: Task<Void, Never>?
  
  private let module: UserModuleProtocol
  private let dataStore: UserDataStore
  
  init(module: UserModuleProtocol = UserModule(), dataStore: UserDataStore = UserDataStore()) {
    self.module = module
    self.dataStore = dataStore
  }
  
  func signIn() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let token = try await self.module.loginUser(email: self.email, password: self.password)
        await self.updateLocalUser(token)
        
        self.state = .loaded(token)
      } catch {
        self.state = .error("Unable to sign in. Please try again")
        MusculosLogger.logError(error: error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  func signUp() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let token = try await self.module.registerUser(email: self.email,
                                                       password: self.password,
                                                       username: self.username,
                                                       fullName: self.fullName)
        await self.updateLocalUser(token)
        self.state = .loaded(token)
      } catch {
        self.state = .error("Unable to sign up. Please try again")
        MusculosLogger.logError(error: error, message: "Sign up failed", category: .networking)
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
  private func updateLocalUser(_ token: String) async {
    let person = Person(email: self.email, fullName: self.fullName, username: self.username)
    await dataStore.createUserProfile(person: person)
    
    UserDefaults.standard.setValue(token, forKey: token)
  }
}

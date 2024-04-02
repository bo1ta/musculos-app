//
//  AuthViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
  @Published var state: LoadingViewState<Bool> = .empty
  @Published var email: String = ""
  @Published var password: String = ""
  @Published var username: String = ""
  @Published var fullName: String = ""
  @Published var showRegister: Bool = false
  
  private(set) var authTask: Task<Void, Never>?
  
  private let module: Authenticatable
  private let dataStore: UserDataStore?
  
  init(module: Authenticatable = AuthModule(), dataStore: UserDataStore? = UserDataStore()) {
    self.module = module
    self.dataStore = dataStore
  }
  
  func signIn() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let token = try await self.module.login(email: self.email, password: self.password)
        await self.saveLocalUser(token)
        
        self.state = .loaded(true)
      } catch {
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  func signUp() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        let token = try await self.module.register(email: self.email,
                                                   password: self.password,
                                                   username: self.username,
                                                   fullName: self.fullName)
        await self.saveLocalUser(token)
        self.state = .loaded(true)
      } catch {
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
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
    guard let dataStore else { return }
    
    let person = Person(email: self.email, fullName: self.fullName, username: self.username)
    await dataStore.createUserProfile(person: person)
    UserDefaults.standard.setValue(token, forKey: UserDefaultsKeyConstant.authToken.rawValue)
  }
}

extension AuthViewModel: @unchecked Sendable {}

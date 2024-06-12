//
//  AuthViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import Combine

@Observable
class AuthViewModel {
  var state: LoadingViewState<Bool> = .empty
  var email: String = ""
  var password: String = ""
  var username: String = ""
  var fullName: String = ""
  var showRegister: Bool = false
  
  private(set) var authTask: Task<Void, Never>?
  
  private let module: Authenticatable
  
  init(module: Authenticatable = AuthModule()) {
    self.module = module
  }
  
  func signIn() {
    authTask = Task { @MainActor [weak self] in
      guard let self else { return }
      self.state = .loading
      
      do {
        try await self.module.login(
          email: self.email,
          password: self.password
        )
  
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
        try await self.module.register(
          email: self.email,
          password: self.password,
          username: self.username,
          fullName: self.fullName
        )
    
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

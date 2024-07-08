//
//  AuthViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import Combine
import Utility

@Observable
@MainActor
class AuthViewModel {
  var state: LoadingViewState<Bool> = .empty
  var email: String = ""
  var password: String = ""
  var username: String = ""
  var fullName: String = ""
  var showRegister: Bool = false
  
  private(set) var authTask: Task<Void, Never>?
  
  private let service: AuthServiceProtocol
  
  init(service: AuthServiceProtocol = AuthService()) {
    self.service = service
  }
  
  func signIn() {
    authTask?.cancel()
    
    authTask = Task {
      state = .loading
      
      do {
        try await service.login(email: email, password: password)
        state = .loaded(true)
      } catch {
        self.state = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  func signUp() {
    authTask?.cancel()
    
    authTask = Task {
      state = .loading
      
      do {
        try await service.register(
          email: email,
          password: password,
          username: username,
          fullName: fullName
        )
    
        state = .loaded(true)
      } catch {
        state = .error(MessageConstant.genericErrorMessage.rawValue)
        MusculosLogger.logError(error, message: "Sign up failed", category: .networking)
      }
    }
  }
  
  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }
}

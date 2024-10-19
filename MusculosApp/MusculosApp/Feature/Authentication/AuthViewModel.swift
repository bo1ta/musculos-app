//
//  AuthViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Foundation
import Combine
import Utility
import SwiftUI
import Models
import DataRepository
import Factory

@Observable
@MainActor
class AuthViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userRepository) private var repository: UserRepository

  // MARK: - Auth step

  enum Step {
    case login
    case register
  }

  // MARK: - Event

  enum Event {
    case onLoginSuccess(UserSession)
    case onLoginFailure(Error)
    case onRegisterSuccess(UserSession)
    case onRegisterFailure(Error)
  }

  // MARK: - Public

  var step: Step
  var uiState: UIState = .idle
  var email  = ""
  var username  = ""
  var password = ""
  var confirmPassword = ""

  var event: AnyPublisher<Event, Never> {
    _event.eraseToAnyPublisher()
  }

  var isLoginFormValid: Bool {
    return RegexValidator.isValidEmail(email) && RegexValidator.isValidPassword(password)
  }

  var isRegisterFormValid: Bool {
    return RegexValidator.isValidEmail(email) && RegexValidator.isValidUsername(username) && RegexValidator.isValidPassword(password) && password == confirmPassword
  }

  private(set) var authTask: Task<Void, Never>?
  private let _event = PassthroughSubject<Event, Never>()

  init(initialStep: Step) {
    self.step = initialStep
  }

  func signIn() {
    authTask?.cancel()
    
    authTask = Task { [weak self] in
      guard let self else { return }

      uiState = .loading
      defer { uiState = .idle }

      do {
        let session = try await repository.login(email: email, password: password)
        _event.send(.onLoginSuccess(session))
      } catch {
        _event.send(.onLoginFailure(error))
        MusculosLogger.logError(error, message: "Sign in failed", category: .networking)
      }
    }
  }
  
  func signUp() {
    authTask?.cancel()
    
    authTask = Task { [weak self] in
      guard let self else { return }

      uiState = .loading
      defer { uiState = .idle }

      do {
        let session = try await repository.register(
          email: email,
          password: password,
          username: username
        )
        _event.send(.onRegisterSuccess(session))
      } catch {
        _event.send(.onRegisterFailure(error))
        MusculosLogger.logError(error, message: "Sign Up failed", category: .networking)
      }
    }
  }
  
  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }

  func makeLoadingBinding() -> Binding<Bool> {
    Binding(get: {
      return self.uiState == .loading
    }, set: {
      self.uiState = $0 ? .loading : .idle
    })
  }
}

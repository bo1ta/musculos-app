//
//  AuthenticationViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Combine
import DataRepository
import Factory
import Foundation
import Models
import SwiftUI
import Utility

@Observable
@MainActor
class AuthenticationViewModel {
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

  var email = ""
  var username = ""
  var password = ""
  var confirmPassword = ""
  var isLoading: Bool = false

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  var isLoginFormValid: Bool {
    return RegexValidator.isValidEmail(email) && RegexValidator.isValidPassword(password)
  }

  var isRegisterFormValid: Bool {
    return RegexValidator.isValidEmail(email) && RegexValidator.isValidUsername(username) && RegexValidator.isValidPassword(password) && password == confirmPassword
  }

  private(set) var authTask: Task<Void, Never>?
  private let eventSubject = PassthroughSubject<Event, Never>()

  var step: Step

  init(initialStep: Step) {
    step = initialStep
  }

  func signIn() {
    authTask?.cancel()

    authTask = Task { [weak self] in
      guard let self else {
        return
      }

      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.login(email: email, password: password)
        sendEvent(.onLoginSuccess(session))
      } catch {
        sendEvent(.onLoginFailure(error))
        Logger.error(error, message: "Sign in failed")
      }
    }
  }

  func signUp() {
    authTask?.cancel()

    authTask = Task { [weak self] in
      guard let self else {
        return
      }

      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.register(
          email: email,
          password: password,
          username: username
        )
        sendEvent(.onRegisterSuccess(session))
      } catch {
        sendEvent(.onRegisterFailure(error))
        Logger.error(error, message: "Sign Up failed")
      }
    }
  }

  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }
}

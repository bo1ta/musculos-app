//
//  AuthenticationViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.03.2024.
//

import Combine
import Components
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
  @LazyInjected(\DataRepositoryContainer.userRepository) private var repository: UserRepositoryProtocol

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.authenticationManager) private var authManager: AuthenticationManagerProtocol

  @ObservationIgnored
  @LazyInjected(\.toastManager) private var toastManager: ToastManagerProtocol

  // MARK: - Auth step

  enum Step {
    case login
    case register
  }

  // MARK: - Public

  var email = ""
  var username = ""
  var password = ""
  var confirmPassword = ""
  var isLoading = false

  var isLoginFormValid: Bool {
    RegexValidator.isValidEmail(email) && RegexValidator.isValidPassword(password)
  }

  var isRegisterFormValid: Bool {
    RegexValidator.isValidEmail(email) && RegexValidator.isValidUsername(username) && RegexValidator
      .isValidPassword(password) && password == confirmPassword
  }

  private(set) var authTask: Task<Void, Never>?

  var step: Step

  init(initialStep: Step) {
    step = initialStep
  }

  func signIn() {
    authTask = Task {
      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.login(email: email, password: password)
        authManager.authenticateSession(session)
      } catch {
        toastManager.showError("An error occured while signing in")
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
        let session = try await repository.register(email: email, password: password, username: username)
        authManager.authenticateSession(session)
      } catch {
        toastManager.showError("An error occured while signing up")
        Logger.error(error, message: "Sign Up failed")
      }
    }
  }

  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }
}

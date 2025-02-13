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
class AuthenticationViewModel: BaseViewModel {

  @ObservationIgnored
  @LazyInjected(\DataRepositoryContainer.userRepository) private var repository: UserRepositoryProtocol

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

  var step: Step

  init(initialStep: Step) {
    step = initialStep
  }

  func signIn() {
    Task {
      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.login(email: email, password: password)
        await userStore.authenticateSession(session)
      } catch {
        toastManager.showError("An error occured while signing in")
        Logger.error(error, message: "Sign in failed")
      }
    }
  }

  func signUp() {
    Task {
      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.register(email: email, password: password, username: username)
        await userStore.authenticateSession(session)
      } catch {
        toastManager.showError("An error occured while signing up")
        Logger.error(error, message: "Sign Up failed")
      }
    }
  }
}

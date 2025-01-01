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
  @Injected(\DataRepositoryContainer.userRepository) private var repository: UserRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStore

  @ObservationIgnored
  @Injected(\.toastService) private var toastService: ToastService

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
    authTask?.cancel()

    authTask = Task { [weak self] in
      guard let self else {
        return
      }

      isLoading = true
      defer { isLoading = false }

      do {
        let session = try await repository.login(email: email, password: password)
        await userStore.authenticateSession(session)
      } catch {
        toastService.error("An error occured while signing in")
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
        await userStore.authenticateSession(session)
      } catch {
        toastService.error("An error occured while signing up")
        Logger.error(error, message: "Sign Up failed")
      }
    }
  }

  func cleanUp() {
    authTask?.cancel()
    authTask = nil
  }
}

//
//  LoginViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import Foundation
import SwiftUI
import Combine
import Supabase

final class AuthenticationViewModel: ObservableObject {
  @Published var currentStep: AuthenticationStep = .login
  @Published var email = ""
  @Published var username = ""
  @Published var password = ""
  @Published var isFormValid = false
  @Published var isLoading = false
  @Published var isAuthenticated = false
  @Published var showErrorAlert = false
  
  private(set) var loginTask: Task<Void, Never>?
  private(set) var registerTask: Task<Void, Never>?
  private var formValidationCancellable: AnyCancellable?

  var errorMessage: String? {
    didSet {
      self.showErrorAlert = self.errorMessage != nil
    }
  }

  private let module: AuthenticationModuleProtocol

  init(module: AuthenticationModuleProtocol = AuthenticationModule()) {
    self.module = module
    self.setupFormValidation()
  }

  private func setupFormValidation() {
    self.formValidationCancellable = self.isLoginFormValidPublisher
      .receive(on: RunLoop.main)
      .sink(receiveValue: { [weak self] isValid in
        guard let self else { return }
        self.isFormValid = isValid
      })
  }

  public func handleNextStep() {
    self.currentStep = self.currentStep == .login ? .register : .login
  }
}

// MARK: - Authentication methods

extension AuthenticationViewModel {
  public func handleAuthentication() {
    if self.currentStep == .login {
      self.loginUser()
    } else if self.currentStep == .register {
      self.registerUser()
    }
  }
  
  private func loginUser() {
    loginTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.errorMessage = nil
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        try await self.module.loginUser(email: self.email, password: self.password)
      } catch {
        self.errorMessage = error.localizedDescription
      }
    }
  }
  
  private func registerUser() {
    registerTask = Task { @MainActor [weak self] in
      guard let self else { return }
      
      self.errorMessage = nil
      self.isLoading = true
      defer { self.isLoading = false }
      
      do {
        let extraData: [String: AnyJSON] = [
          "username": .string(self.username)
        ]
        try await self.module.registerUser(email: self.email, password: self.password, extraData: extraData)
      } catch {
        self.errorMessage = error.localizedDescription
      }
    }
  }
  
  private func saveAuthenticationState() {
    UserDefaultsWrapper.shared.isAuthenticated = true
  }
}

// MARK: - Form validation

extension AuthenticationViewModel {
  private var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
    $username
      .map { $0.count >= 5 }
      .eraseToAnyPublisher()
  }

  private var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
    $password
      .map { $0.count >= 6 }
      .eraseToAnyPublisher()
  }

  private var isLoginFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest(isEmailFormValidPublisher, isPasswordValidPublisher)
      .map { $0 && $1 }
      .eraseToAnyPublisher()
  }

  private var isEmailFormValidPublisher: AnyPublisher<Bool, Never> {
    $email
      .map { $0.count >= 5 }
      .eraseToAnyPublisher()
  }

  private var isRegisterFormValidPublisher: AnyPublisher<Bool, Never> {
    Publishers.CombineLatest3(isEmailFormValidPublisher, isUsernameValidPublisher, isPasswordValidPublisher)
      .map { $0 && $1 && $2 }
      .eraseToAnyPublisher()
  }
}

extension AuthenticationViewModel {
  enum AuthenticationStep: String {
    case login, register
  }
}

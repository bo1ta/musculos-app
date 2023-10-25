//
//  LoginViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var currentStep: AuthenticationStep = .login
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var isFormValid = false
    @Published var isLoading = false
    @Published var showErrorAlert = false

    var errorMessage: String? {
        didSet {
            self.showErrorAlert = self.errorMessage != nil
        }
    }

    private var cancellables = Set<AnyCancellable>()
    private var formValidationCancellable: AnyCancellable?

    let authSuccess = PassthroughSubject<Void, Never>()
    private let module: AuthenticationModule

    init(module: AuthenticationModule = AuthenticationModule()) {
        self.module = module
        self.setupFormValidation()
    }

    private func setupFormValidation() {
        self.formValidationCancellable = $currentStep.combineLatest(isLoginFormValidPublisher, isRegisterFormValidPublisher)
            .receive(on: RunLoop.main)
            .sink(receiveValue: { [weak self] currentStep, isLoginFormValid, isRegisterFormValid in
                var isValid = false

                switch currentStep {
                case .login:
                    isValid = isLoginFormValid
                case .register:
                    isValid = isRegisterFormValid
                }

                self?.isFormValid = isValid
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
        self.isLoading = true

        Task {
            do {
                let response = try await self.module.loginUser(email: self.email, password: self.password)
                UserDefaultsWrapper.shared.authToken = response.token
                self.isLoading = false
                self.authSuccess.send()
            } catch let err {
                self.isLoading = false
                self.errorMessage = err.localizedDescription
            }
        }
    }

    private func registerUser() {
        self.isLoading = true

        Task {
            do {
                let response = try await self.module.registerUser(username: self.username, email: self.email, password: self.password)
                UserDefaultsWrapper.shared.authToken = response.token
                self.isLoading = false
                self.authSuccess.send()
            } catch let err {
                self.isLoading = false
                self.errorMessage = err.localizedDescription
            }
        }
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
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
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
        case  login, register
    }
}

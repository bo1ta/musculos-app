//
//  LoginViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import Foundation
import SwiftUI
import Combine

final class LoginViewModel: ObservableObject {
    enum AuthenticationStep: String {
        case login, register
    }
    
    @Published var email = ""
    @Published var username = ""
    @Published var password = ""
    @Published var isFormValid = false
    @Published var hasToken = false
    @Published var isLoading = false
    @Published var showErrorAlert = false
    
    @Published var currentStep: AuthenticationStep = .login
    
    var errorMessage: String? {
        didSet {
            self.showErrorAlert = self.errorMessage != nil
        }
    }
    
    private var cancellables = Set<AnyCancellable>()
    private var formValidationCancellable: AnyCancellable?
    
    private let authenticationHelper: AuthenticationHelper?
    
    init(authenticationHelper: AuthenticationHelper = AuthenticationHelper()) {
        self.authenticationHelper = authenticationHelper
        
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
}

// MARK: - Authentication methods

extension LoginViewModel {
    public func handleNextStep() {
        self.currentStep = self.currentStep == .login ? .register : .login
    }
    
    public func setupSubscriptions() {
        self.$hasToken.sink { hasToken in
            if !self.isLoading && hasToken {
                print("Ready to navigate")
            }
        }
        .store(in: &cancellables)
    }
    
    public func handleAuthentication() {
        if self.currentStep == .login {
            self.loginUser()
        } else if self.currentStep == .register {
            self.registerUser()
        }
    }
    
    public func loginUser() {
        self.isLoading = true
        
        guard let authenticationHelper = self.authenticationHelper else { return }
        authenticationHelper.authenticateUser(with: self.email, password: self.password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let networkError):
                    self.errorMessage = networkError.description
                    print(networkError)
                    break
                case .finished:
                    print("Finished!")
                    break
                }
                self.isLoading = false
            } receiveValue: { [weak self] response in
                print("Got the token: \(response.token)")
                self?.hasToken = true
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    public func registerUser() {
        self.isLoading = true
        
        guard let authenticationHelper = self.authenticationHelper else { return }
        authenticationHelper.registerUser(username: self.username, email: self.email, password: self.password)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let self = self else { return }
                
                switch completion {
                case .failure(let networkError):
                    self.errorMessage = networkError.description
                    print(networkError)
                    break
                case .finished:
                    print("Finished!")
                    break
                }
                self.isLoading = false
            } receiveValue: { [weak self] response in
                print("Got the token: \(response.token)")
                print("And the user: \(response.user)")
                self?.hasToken = true
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
}

// MARK: - Form validation
extension LoginViewModel {
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

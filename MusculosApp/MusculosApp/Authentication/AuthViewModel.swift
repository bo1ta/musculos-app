//
//  LoginViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2023.
//

import Foundation
import SwiftUI
import Combine

final class AuthViewModel: ObservableObject {
    enum AuthenticationStep: String {
        case  login, register
    }
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
    private let authenticationHelper: AuthenticationModule?
    
    init(authenticationHelper: AuthenticationModule = AuthenticationModule()) {
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
    
    public func handleNextStep() {
        self.currentStep = self.currentStep == .login ? .register : .login
    }
}

// MARK: - Authentication methods

extension AuthViewModel {
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
                UserDefaultsWrapper.shared.authToken = response.token
                self?.isLoading = false
                self?.authSuccess.send()
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
                    break
                case .finished:
                    break
                }
                self.isLoading = false
            } receiveValue: { [weak self] response in
                self?.isLoading = false
                self?.authSuccess.send()
            }
            .store(in: &cancellables)
    }
}

// MARK: - Form validation

extension AuthViewModel {
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

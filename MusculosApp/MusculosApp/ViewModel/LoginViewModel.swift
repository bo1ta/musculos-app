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
    @Published var username = ""
    @Published var password = ""
    @Published var isFormValid = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        isLoginFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
}

extension LoginViewModel {
    public func authenticateUser() {
        let authenticationHelper = AuthenticationHelper()
        authenticationHelper.authenticateUser(with: self.username, password: self.password)
    }
}

extension LoginViewModel {
    var isUsernameValidPublisher: AnyPublisher<Bool, Never> {
        $username
            .map { $0.count >= 5 }
            .eraseToAnyPublisher()
    }
    
    var isPasswordValidPublisher: AnyPublisher<Bool, Never> {
        $password
            .map { $0.count >= 6 }
            .eraseToAnyPublisher()
    }
    
    var isLoginFormValidPublisher: AnyPublisher<Bool, Never> {
        Publishers.CombineLatest(isUsernameValidPublisher, isPasswordValidPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
}

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
    
    @Published var hasToken = false
    @State var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    var overrideAuthenticationHelper: AuthenticationHelper?
    private var authenticationHelper: AuthenticationHelper {
        return self.overrideAuthenticationHelper ?? AuthenticationHelper()
    }
    
    init() {
        isLoginFormValidPublisher
            .receive(on: RunLoop.main)
            .assign(to: \.isFormValid, on: self)
            .store(in: &cancellables)
    }
    
    func setupSubscriptions() {
        self.$hasToken.sink { hasToken in
            if !self.isLoading && hasToken {
                print("Ready to navigate")
            }
        }
        .store(in: &cancellables)
    }
}

extension LoginViewModel {
    public func authenticateUser() {
        self.isLoading = true
        
        self.authenticationHelper
            .authenticateUser(with: self.username, password: self.password)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let networkError):
                    print(networkError)
                    break
                case .finished:
                    print("Finished!")
                    break
                }
                self?.isLoading = false
            } receiveValue: { [weak self] response in
                print("Got the token: \(response.token)")
                self?.hasToken = true
                self?.isLoading = false
            }
            .store(in: &cancellables)
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

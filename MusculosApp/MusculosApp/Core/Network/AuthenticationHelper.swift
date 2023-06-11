//
//  AuthenticationHelper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine

public class AuthenticationHelper: NSObject {
    private let dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
    func authenticateUser(with email: String, password: String) -> AnyPublisher<LoginResponse, NetworkRequestError> {
        let dictionary: [String: Any] = ["email": email, "password": password]
        let request = LoginRequest(body: dictionary)
        let client = MusculosClient(baseURL: request.path, networkDispatcher: self.dispatcher)
        return client.dispatch(request)
            .eraseToAnyPublisher()
    }
    
    func registerUser(username: String, email: String, password: String) -> AnyPublisher<RegisterResponse, NetworkRequestError> {
        let dictionary: [String: Any] = ["user_name": username, "email": email, "password": password]
        let request = RegisterRequest(body: dictionary)
        let client = MusculosClient(baseURL: request.path, networkDispatcher: self.dispatcher)
        return client.dispatch(request)
            .eraseToAnyPublisher()
    }
}

//
//  AuthenticationModule.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine

public class AuthenticationModule: NetworkModule {
    var dispatcher: NetworkDispatcher
    
    init(dispatcher: NetworkDispatcher = NetworkDispatcher()) {
        self.dispatcher = dispatcher
    }
    
    func authenticateUser(with email: String, password: String) -> AnyPublisher<LoginResponse, NetworkRequestError> {
        let model = Login(email: email, password: password)
        let request = LoginRequest(body: model.asDictionary)
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

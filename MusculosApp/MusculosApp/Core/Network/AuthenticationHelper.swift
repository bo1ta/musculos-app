//
//  AuthenticationHelper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Combine

struct AuthenticationResponse: Codable {
    var token: String
}

struct AuthenticationRequest: Request {
    var headers: [String : String]?
    
    typealias ReturnType = AuthenticationResponse
    
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .authentication)
    var method: HTTPMethod = .post
    var body: [String: Any]
    
    init(body: [String: Any]) {
        self.body = body
    }
}

public class AuthenticationHelper: NSObject {
    private let loginEndpoint = APIEndpoint.baseWithEndpoint(endpoint: .authentication)
    private let dispatcher = NetworkDispatcher()
    
    func authenticateUser(with email: String, password: String) -> AnyPublisher<AuthenticationResponse, NetworkRequestError> {
        let dictionary: [String: Any] = ["email": email, "password": password]
        let request = AuthenticationRequest(body: dictionary)
        let client = MusculosClient(baseURL: request.path, networkDispatcher: self.dispatcher)
        return client.dispatch(request).eraseToAnyPublisher()
    }
}

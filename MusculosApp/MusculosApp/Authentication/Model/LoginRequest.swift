//
//  LoginRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation

struct Login: Codable {
    var email: String
    var password: String
}

struct LoginResponse: Codable {
    var token: String
}

struct LoginRequest: Request {
    var headers: [String : String]?
    
    typealias ReturnType = LoginResponse
    
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .authentication)
    var method: HTTPMethod = .post
    var body: [String: Any]?
    
    init(body: [String: Any]?) {
        self.body = body
    }
}

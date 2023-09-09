//
//  RegisterRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 11.06.2023.
//

import Foundation

struct User: Codable {
    var userName: String
    var id: Int
    var email: String
}

struct RegisterResponse: Codable, DecodableModel {
    var user: User
    var token: String
}

struct RegisterRequest: Request {
    typealias ReturnType = RegisterResponse
    
    var path: String = APIEndpoint.baseWithEndpoint(endpoint: .register)
    var method: HTTPMethod = .post
    var body: [String: Any]?
    
    init(body: [String: Any]) {
        self.body = body
    }
}

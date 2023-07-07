//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

enum Endpoint: String {
    case authentication = "/auth/login"
    case register       = "/users"
    case persons        = "/persons"
    case questions      = "/questions"
    case userAnswers    = "/user-answers"
}

public class APIEndpoint {
    static let base = "http://0.0.0.0:3000"
    
    static func baseWithEndpoint(endpoint: Endpoint) -> String {
        return Self.base + endpoint.rawValue
    }
}

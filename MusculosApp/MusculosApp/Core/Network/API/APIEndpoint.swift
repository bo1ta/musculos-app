//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation

enum Endpoint: String {
    case authentication = "/user/login"
    case register       = "/user/register"
    case persons        = "/persons"
    case questions      = "/api/questions"
    case userAnswers    = "/user-answers"
    case muscle         = "/muscle"
    case equipment      = "/equipment"
}

public class APIEndpoint {
    static let base = "http://127.0.0.1:8080"
    
    static func baseWithEndpoint(endpoint: Endpoint) -> String {
        return Self.base + endpoint.rawValue
    }
}

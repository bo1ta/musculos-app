//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum Endpoint: CustomStringConvertible {
  case login
  case register
  case exercises
  case exercisesByMuscle

  var description: String {
    switch self {
    case .login:
      return "/me/login"
    case .register:
      return "/me/register"
    case .exercises:
      return "/db0/exercises"
    case .exercisesByMuscle:
      return "/db0/searchMuscle"
    }
  }
}

public class APIEndpoint {
  static let base = "http://49.13.172.88:3000"

  static func baseWithEndpoint(endpoint: Endpoint) -> String {
    return Self.base + endpoint.description
  }
}

//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum Endpoint {
  case login, register, exercises, exercisesByMuscle

  var path: String {
    switch self {
    case .login:
      return "/users/login"
    case .register:
      return "/users/register"
    case .exercises:
      return "/exercises"
    case .exercisesByMuscle:
      return "/db0/searchMuscle"
    }
  }
}

struct APIEndpoint {
  private static let base = "http://musclehustle.xyz:3000/api/v1/"

  static func baseWithEndpoint(endpoint: Endpoint) -> URL? {
    return URL(
      string: Self.base + endpoint.path
    )
  }
}

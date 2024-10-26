//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

public enum Endpoint {
  case users(APIRoute.UsersRoute)
  case exercises(APIRoute.ExercisesRoute)
  case exerciseSessions(APIRoute.ExerciseSessionsRoute)
  case goals(APIRoute.GoalsRoute)
  case templates(APIRoute.TemplatesRoute)

  public var path: String {
    switch self {
    case .users(let route):
      return "/users/\(route.path)"
    case .exercises(let route):
      return "/exercises/\(route.path)"
    case .exerciseSessions(let route):
      return "/exercise-sessions/\(route.path)"
    case .goals(let route):
      return "/goals/\(route.path)"
    case .templates(let route):
      return "/templates/\(route.path)"
    }
  }

  public var isAuthorizationRequired: Bool {
    switch self {
    case .users(let endpoint):
      switch endpoint {
      case .login, .register:
        return false
      default:
        return true
      }
    default:
      return true
    }
  }
}

public struct APIEndpoint {
  private static let base = "http://musclehustle.xyz:3000/api/v1"

  static func baseWithEndpoint(endpoint: Endpoint) -> URL? {
    return URL(
      string: Self.base + endpoint.path
    )
  }
}

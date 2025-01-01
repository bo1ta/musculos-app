//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

// MARK: - Endpoint

public enum Endpoint {
  case users(APIRoute.UsersRoute)
  case exercises(APIRoute.ExercisesRoute)
  case exerciseSessions(APIRoute.ExerciseSessionsRoute)
  case goals(APIRoute.GoalsRoute)
  case templates(APIRoute.TemplatesRoute)
  case ratings(APIRoute.RatingsRoute)
  case images(APIRoute.ImagesRoute)

  public var path: String {
    switch self {
    case .users(let route):
      "/users/\(route.path)"
    case .exercises(let route):
      "/exercises/\(route.path)"
    case .exerciseSessions(let route):
      "/exercise-session/\(route.path)"
    case .goals(let route):
      "/goals/\(route.path)"
    case .templates(let route):
      "/templates/\(route.path)"
    case .ratings(let route):
      "/ratings/\(route.path)"
    case .images(let route):
      "/images/\(route.path)"
    }
  }

  public var isAuthorizationRequired: Bool {
    switch self {
    case .users(let endpoint):
      switch endpoint {
      case .login, .register:
        false
      default:
        true
      }

    default:
      true
    }
  }
}

// MARK: - APIEndpoint

public enum APIEndpoint {
  private static let base = "http://musclehustle.xyz:3000/api/v1"
  private static let publicBase = "http://musclehustle.xyz:3000"

  static func baseWithEndpoint(endpoint: Endpoint) -> URL? {
    URL(string: base + endpoint.path)
  }

  static func baseWithPath(_ path: String) -> URL? {
    URL(string: publicBase + path)
  }
}

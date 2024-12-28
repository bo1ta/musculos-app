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
  case ratings(APIRoute.RatingsRoute)
  case images(APIRoute.ImagesRoute)

  public var path: String {
    switch self {
    case let .users(route):
      return "/users/\(route.path)"
    case let .exercises(route):
      return "/exercises/\(route.path)"
    case let .exerciseSessions(route):
      return "/exercise-session/\(route.path)"
    case let .goals(route):
      return "/goals/\(route.path)"
    case let .templates(route):
      return "/templates/\(route.path)"
    case let .ratings(route):
      return "/ratings/\(route.path)"
    case let .images(route):
      return "/images/\(route.path)"
    }
  }

  public var isAuthorizationRequired: Bool {
    switch self {
    case let .users(endpoint):
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

public enum APIEndpoint {
  private static let base = "http://musclehustle.xyz:3000/api/v1"
  private static let publicBase = "http://musclehustle.xyz:3000"

  static func baseWithEndpoint(endpoint: Endpoint) -> URL? {
    return URL(string: base + endpoint.path)
  }

  static func baseWithPath(_ path: String) -> URL? {
    return URL(string: publicBase + path)
  }
}

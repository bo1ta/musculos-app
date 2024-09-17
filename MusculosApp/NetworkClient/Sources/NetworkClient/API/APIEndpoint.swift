//
//  APIEndpoint.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

public enum Endpoint {
  case login, register, exercises, exercisesByMuscle, favoriteExercise, currentProfile, updateProfile
  case exerciseDetails(_ exerciseID: UUID)

  public var path: String {
    switch self {
    case .login:
      return "/users/login"
    case .register:
      return "/users/register"
    case .exercises:
      return "/exercises"
    case let .exerciseDetails(exerciseID):
      return "/exercises/\(exerciseID)"
    case .favoriteExercise:
      return "/exercises/favorites"
    case .updateProfile:
      return "/users/me/update-profile"
    case .currentProfile:
      return "/users/me"
    case .exercisesByMuscle:
      return "/db0/searchMuscle"
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

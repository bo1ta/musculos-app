//
//  APIRoute.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models

public enum APIRoute {
  public enum UsersRoute {
    case login
    case register
    case currentProfile
    case updateProfile

    public var path: String {
      switch self {
      case .login: "login"
      case .register: "register"
      case .currentProfile: "me"
      case .updateProfile: "me/update-profile"
      }
    }
  }

  public enum ExercisesRoute {
    case index
    case exerciseDetails(UUID)
    case favoriteExercises
    case exercisesByGoals
    case filtered

    public var path: String {
      switch self {
      case .index: ""
      case .exerciseDetails(let id): "\(id)"
      case .favoriteExercises: "favorites"
      case .exercisesByGoals: "getByGoals"
      case .filtered: "filtered"
      }
    }
  }

  public enum ExerciseSessionsRoute {
    case index

    public var path: String {
      switch self {
      case .index: ""
      }
    }
  }

  public enum GoalsRoute {
    case index
    case goalDetails(UUID)
    case updateProgress

    public var path: String {
      switch self {
      case .index: ""
      case .goalDetails(let id): "\(id)"
      case .updateProgress: "update-progress"
      }
    }
  }

  public enum TemplatesRoute {
    case goals

    public var path: String {
      switch self {
      case .goals: "goals"
      }
    }
  }

  public enum RatingsRoute {
    case index
    case exerciseID(UUID)

    public var path: String {
      switch self {
      case .index: ""
      case .exerciseID(let exerciseID): exerciseID.uuidString
      }
    }
  }

  public enum ImagesRoute {
    case upload

    public var path: String {
      switch self {
      case .upload: "upload"
      }
    }
  }

  public enum WorkoutChallengesRoute {
    case index
    case generate

    public var path: String {
      switch self {
      case .index: ""
      case .generate: "generate"
      }
    }
  }
}

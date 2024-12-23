//
//  Routes.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models

public struct APIRoute {
  public enum UsersRoute {
    case login
    case register
    case currentProfile
    case updateProfile
    
    public var path: String {
      switch self {
      case .login: return "login"
      case .register: return "register"
      case .currentProfile: return "me"
      case .updateProfile: return "me/update-profile"
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
      case .index: return ""
      case .exerciseDetails(let id): return "\(id)"
      case .favoriteExercises: return "favorites"
      case .exercisesByGoals: return "getByGoals"
      case .filtered: return "filtered"
      }
    }
  }
  
  public enum ExerciseSessionsRoute {
    case index
    
    public var path: String {
      switch self {
      case .index: return ""
      }
    }
  }
  
  public enum GoalsRoute {
    case index
    case goalDetails(UUID)
    case updateProgress
    
    public var path: String {
      switch self {
      case .index: return ""
      case .goalDetails(let id): return "\(id)"
      case .updateProgress: return "update-progress"
      }
    }
  }
  
  public enum TemplatesRoute {
    case goals
    
    public var path: String {
      switch self {
      case .goals: return "goals"
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
}

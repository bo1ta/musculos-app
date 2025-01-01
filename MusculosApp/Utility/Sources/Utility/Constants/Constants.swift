//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation

// MARK: - HTTPMethod

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

// MARK: - HTTPHeaderConstant

public enum HTTPHeaderConstant {
  public static let contentType = "Content-Type"
  public static let authorization = "Authorization"
}

// MARK: - UIConstant

public enum UIConstant {
  public static let componentOpacity = 0.95

  public static let shortAnimationDuration = 0.1
  public static let mediumAnimationDuration = 0.25
  public static let longAnimationDuration = 0.5

  public static let smallIconSize = 16.0
  public static let mediumIconSize = 23.0
  public static let largeIconSize = 25.0

  public enum Size {
    case extraSmall, small, medium, large

    public var cardHeight: Double {
      switch self {
      case .extraSmall: 45.0
      case .small: 75.0
      case .medium: 150.0
      case .large: 200.0
      }
    }

    public var iconHeight: Double {
      switch self {
      case .extraSmall: 10.0
      case .small: 16.0
      case .medium: 23.0
      case .large: 30.0
      }
    }

    public var cornerRadius: Double {
      switch self {
      case .extraSmall: 5.0
      case .small: 10.0
      case .medium: 15.0
      case .large: 20.0
      }
    }
  }
}

// MARK: - UserDefaultsKey

public enum UserDefaultsKey {
  public static let userSession = "user_session"
  public static let healthKitAnchor = "health_kit_anchor"
  public static let coreDataModelVersion = "core_data_model_version"

  public static let goalsLastUpdated = "goals_last_updated"
  public static let exercisesLastUpdated = "exercises_last_updated"
  public static let exerciseSessionsLastUpdated = "exercise_sessions_last_updated"

  public static func syncDate(for entityName: String) -> String {
    "\(entityName)_sync_lastUpdatedAt"
  }
}

// MARK: - MessageConstant

public enum MessageConstant: String {
  case genericErrorMessage = "Something went wrong. Please try again"
}

// MARK: - ModelUpdatedEvent

public enum ModelUpdatedEvent {
  case didAddGoal
  case didAddExerciseSession
  case didAddExercise
  case didFavoriteExercise

  public static var userInfoKey: String {
    "ModelUpdatedEventKey"
  }
}

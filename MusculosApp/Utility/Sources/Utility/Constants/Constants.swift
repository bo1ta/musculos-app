//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation

public enum HTTPMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

public struct HTTPHeaderConstant {
  public static let contentType = "Content-Type"
  public static let authorization = "Authorization"
}

public struct UIConstant {
  public static let componentOpacity: Double = 0.95

  public static let shortAnimationDuration: Double = 0.1
  public static let mediumAnimationDuration: Double = 0.25
  public static let longAnimationDuration: Double = 0.5

  public static let smallIconSize: Double = 16.0
  public static let mediumIconSize: Double = 23.0
  public static let largeIconSize: Double = 25.0

  public enum Size {
    case extraSmall, small, medium, large

    public var cardHeight: Double {
      switch self {
      case .extraSmall: return 45.0
      case .small: return 75.0
      case .medium: return 150.0
      case .large: return 200.0
      }
    }

    public var iconHeight: Double {
      switch self {
      case .extraSmall: return 10.0
      case .small: return 16.0
      case .medium: return 23.0
      case .large: return 30.0
      }
    }

    public var cornerRadius: Double {
      switch self {
      case .extraSmall: return 5.0
      case .small: return 10.0
      case .medium: return 15.0
      case .large: return 20.0
      }
    }
  }
}

public struct UserDefaultsKey {
  public static let userSession = "user_session"
  public static let healthKitAnchor = "health_kit_anchor"
}

public enum MessageConstant: String {
  case genericErrorMessage = "Something went wrong. Please try again"
}

public enum ModelUpdatedEvent {
  case didAddGoal
  case didAddExerciseSession
  case didAddExercise
  case didFavoriteExercise

  public static var userInfoKey: String {
    return "ModelUpdatedEventKey"
  }
}

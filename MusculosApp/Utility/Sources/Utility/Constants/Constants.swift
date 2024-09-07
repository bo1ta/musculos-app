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

  public static let defaultAnimationDuration: Double = 0.25

  public static let smallIconSize: Double = 16.0
  public static let mediumIconSize: Double = 23.0
  public static let largeIconSize: Double = 25.0
}

public struct UserDefaultsKey {
  public static let userSession = "user_session"
  public static let authToken = "auth_token"
  public static let isOnboarded = "is_onboarded"
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

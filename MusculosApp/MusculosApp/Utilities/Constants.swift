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
  static let contentType = "Content-Type"
  static let authorization = "Authorization"
}

public struct UIConstant {
  static let componentOpacity: Double = 0.95
  static let standardAnimationTime: Double = 0.25
}

struct UserDefaultsKeyConstant {
  static let healthKitAnchorKey = "health_kit_anchor"
  static let userSessionKey = "user_session_key"
}

public enum MessageConstant: String {
  case genericErrorMessage = "Something went wrong. Please try again"
}

enum ModelUpdatedEvent {
  case didAddGoal
  case didAddExerciseSession
  case didAddExercise
  case didFavoriteExercise

  static var userInfoKey: String {
    return "ModelUpdatedEventKey"
  }
}

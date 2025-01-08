//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation
import SwiftUI

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

  public static let toastStandardDuration = 3.0

  public enum AnimationDuration {
    public static let short = 0.1
    public static let medium = 0.25
    public static let long = 0.5
  }

  public enum CardSize {
    public static let extraSmall = 45.0
    public static let small = 75.0
    public static let medium = 150.0
    public static let large = 200.0
  }

  public enum IconSize {
    public static let extraSmall = 10.0
    public static let small = 16.0
    public static let medium = 23.0
    public static let large = 30.0
  }

  public enum CornerRadius {
    public static let extraSmall = 5.0
    public static let small = 10.0
    public static let medium = 15.0
    public static let large = 20.0
  }

  public enum PresentationDetentState {
    public static let minimized = PresentationDetent.fraction(0.1)
    public static let expanded = PresentationDetent.fraction(0.5)
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

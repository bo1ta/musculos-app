//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation

public enum HTTPMethod: String {
  case get  = "GET"
  case post   = "POST"
  case put  = "PUT"
  case delete = "DELETE"
}

public class HTTPHeaderConstants: NSObject {
  static let contentType = "Content-Type"
  static let authorization = "Authorization"
}

public class UIConstants: NSObject {
  static let componentOpacity: Double = 0.95
}

public class SupabaseConstants: NSObject {
  enum Bucket: String {
    case exerciseImage = "exercise_image"
    case workoutImage = "workout_image"
  }
  
  enum Table: String {
    case exercise
    case favoriteExercise = "favorite_exercise"
  }
}

public enum UserDefaultsKey: String {
  case isAuthenticated = "is_authenticated"
  case isOnboarded = "is_onboarded"
}

public class AppFont: NSObject {
  static let bold = "Roboto-Bold"
  static let light = "Roboto-Light"
  static let regular = "Roboto-Regular"
  static let medium = "Roboto-Medium"
  static let thin = "Roboto-Thin"
}

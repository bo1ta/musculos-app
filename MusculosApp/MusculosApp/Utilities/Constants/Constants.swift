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
}

public enum UserDefaultsKeyConstant: String {
  case isAuthenticated = "is_authenticated"
  case authToken = "auth_token"
  case isOnboarded = "is_onboarded"
  case healthKitAnchor = "health_kit_anchor"
}


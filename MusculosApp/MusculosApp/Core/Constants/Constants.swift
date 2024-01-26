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
  }
  
  enum Table: String {
    case exercise
  }
}

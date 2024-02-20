//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 04.02.2024.
//

import Foundation

struct Exercise: Codable {
  var id: UUID
  var primaryMuscles: [String]
  var secondaryMuscles: [String]
  var force: ForceType?
  var level: Level?
  var equipment: String?
  var category: String?
  var instructions: [String]
  let name: String
  let imageUrls: [String]
  
  enum ForceType: String, Codable {
    case pull, push, stay = "static"
  }
  
  enum Level: String, Codable {
    case intermediate, beginner, expert
  }
  
  func getImagesURLs() -> [URL] {
    guard imageUrls.count > 0 else { return [] }
    
    return imageUrls.compactMap { imageUrlString in
      URL(string: imageUrlString)
    }
  }
}

extension Exercise: DecodableModel { }

extension Exercise: Equatable {
  static func ==(_ lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id
  }
}

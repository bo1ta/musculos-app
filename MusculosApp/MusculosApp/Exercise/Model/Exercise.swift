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
  var imageUrl: URL?
  
  enum CodingKeys: String, CodingKey {
    case id, force, level, equipment, category, instructions, name
    case primaryMuscles = "primary_muscles"
    case secondaryMuscles = "secondary_muscles"
  }
  
  enum ForceType: String, Codable {
    case pull, push, stay = "static"
  }
  
  enum Level: String, Codable {
    case intermediate, beginner, expert
  }

  var imagePath: String {
    let formatted = name.replacingOccurrences(of: " ", with: "_")
    return formatted.replacingOccurrences(of: "/", with: "_")
  }
  
  mutating func setImageUrl(_ imageUrl: URL?) {
    self.imageUrl = imageUrl
  }
}

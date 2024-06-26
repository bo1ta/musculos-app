//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//
//

import Foundation

struct Exercise: Codable {
  public var category: String
  public var equipment: String?
  public var force: String?
  public var id: UUID
  public var level: String
  public var name: String
  public var primaryMuscles: [String]
  public var secondaryMuscles: [String]
  public var instructions: [String]
  public var imageUrls: [String]
  
  init(category: String, equipment: String? = nil, force: String? = nil, id: UUID, level: String, name: String, primaryMuscles: [String], secondaryMuscles: [String], instructions: [String], imageUrls: [String]) {
    self.category = category
    self.equipment = equipment
    self.force = force
    self.id = id
    self.level = level
    self.name = name
    self.primaryMuscles = primaryMuscles
    self.secondaryMuscles = secondaryMuscles
    self.instructions = instructions
    self.imageUrls = imageUrls
  }
  
  var muscleTypes: [MuscleType] {
    var allMuscles = primaryMuscles
    allMuscles.append(contentsOf: secondaryMuscles)
    
    return allMuscles.compactMap { MuscleType(rawValue: $0) }
  }
  
  var primaryMusclesTypes: [MuscleType] {
    return primaryMuscles.compactMap { MuscleType(rawValue: $0) }
  }
  
  var secondaryMusclesTypes: [MuscleType] {
    return secondaryMuscles.compactMap { MuscleType(rawValue: $0) }
  }

  enum CodingKeys: String, CodingKey {
    case category, equipment, force, id, level, name, primaryMuscles, secondaryMuscles, instructions, imageUrls
  }
  
  func getImagesURLs() -> [URL] {
    return imageUrls.compactMap { imageUrlString in
      URL(string: imageUrlString)
    }
  }
}

extension Exercise {
  enum ForceType: String, Codable {
    case pull, push, stay = "static"
  }
  
  enum Level: String, Codable {
    case intermediate, beginner, expert
  }
}

extension Exercise: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.name)
    hasher.combine(self.id)
  }
}

extension Exercise: DecodableModel { }

extension Exercise: Identifiable {
  static func ==(_ lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id
  }
}

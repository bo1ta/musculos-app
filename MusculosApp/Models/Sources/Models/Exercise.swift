//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//
//

import Foundation
import Utility

public struct Exercise: Codable, Sendable {
  public var category: String = ""
  public var equipment: String? = ""
  public var force: String?
  public var id: UUID = UUID()
  public var level: String = ""
  public var name: String = ""
  public var primaryMuscles: [String] = []
  public var secondaryMuscles: [String] = []
  public var instructions: [String] = []
  public var imageUrls: [String] = []
  public var isFavorite: Bool?

  public init(
    category: String,
    equipment: String? = nil,
    force: String? = nil,
    id: UUID,
    level: String,
    name: String,
    primaryMuscles: [String],
    secondaryMuscles: [String],
    instructions: [String],
    imageUrls: [String],
    isFavorite: Bool = false
  ) {
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
    self.isFavorite = isFavorite
  }

  public var muscleTypes: [MuscleType] {
    var allMuscles = primaryMuscles
    allMuscles.append(contentsOf: secondaryMuscles)
    
    return allMuscles.compactMap { MuscleType(rawValue: $0) }
  }
  
  public var primaryMusclesTypes: [MuscleType] {
    return primaryMuscles.compactMap { MuscleType(rawValue: $0) }
  }
  
  public var secondaryMusclesTypes: [MuscleType] {
    return secondaryMuscles.compactMap { MuscleType(rawValue: $0) }
  }

  public var displayOptions: [String] {
    var result: [String] = []

    if let firstMuscle = primaryMuscles.first {
      result.append(firstMuscle)
    }

    if let equipment {
      result.append(equipment)
    }

    result.append(category)

    return result
  }

  enum CodingKeys: String, CodingKey {
    case category, equipment, force, id, level, name, primaryMuscles, secondaryMuscles, instructions, imageUrls, isFavorite
  }
  
  public func getImagesURLs() -> [URL] {
    return imageUrls.compactMap { imageUrlString in
      URL(string: imageUrlString)
    }
  }

  public var displayImageURL: URL? {
    if let firstImageUrl = imageUrls.first {
      return URL(string: firstImageUrl)
    }
    return nil
  }
}

public extension Exercise {
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
  public static func ==(_ lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id
  }
}

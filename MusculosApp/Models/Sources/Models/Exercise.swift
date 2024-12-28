//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//
//

import Foundation
import SwiftUI
import Utility

public struct Exercise: Codable, Sendable {
  public var category: String
  public var equipment: String?
  public var force: String?
  public var id: UUID = .init()
  public var level: String
  public var name: String
  public var primaryMuscles: [String] = []
  public var secondaryMuscles: [String] = []
  public var instructions: [String] = []
  public var imageUrls: [String] = []
  public var isFavorite: Bool?
  public var updatedAt: Date?
  public var ratings: [ExerciseRating]?

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
    isFavorite: Bool = false,
    updatedAt: Date? = nil,
    ratings: [ExerciseRating]? = nil
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
    self.updatedAt = updatedAt
    self.ratings = ratings
  }

  enum CodingKeys: String, CodingKey {
    case category, equipment, force, id, level, name, primaryMuscles, secondaryMuscles, instructions, imageUrls, isFavorite
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

  public var displayName: String {
    let separatedName = name.components(separatedBy: .whitespaces)
    if separatedName.count > 2 {
      return separatedName.prefix(2).joined(separator: " ")
    } else {
      return name
    }
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

  public var equipmentType: ExerciseConstants.EquipmentType {
    guard let equipment else {
      return .other
    }
    return ExerciseConstants.EquipmentType(rawValue: equipment) ?? .other
  }

  public var levelColor: Color {
    switch level {
    case Level.beginner.rawValue:
      .blue
    case Level.intermediate.rawValue:
      .orange
    case Level.expert.rawValue:
      .red
    default:
      .white
    }
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
    hasher.combine(name)
    hasher.combine(id)
  }
}

extension Exercise: DecodableModel {}

extension Exercise: Identifiable {
  public static func == (_ lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id
  }
}

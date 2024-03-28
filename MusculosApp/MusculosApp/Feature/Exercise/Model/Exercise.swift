//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.02.2024.
//
//

import Foundation

final class Exercise: Codable {
  public var category: String
  public var equipment: String?
  public var force: String?
  public var id: UUID?
  public var level: String
  public var name: String
  public var primaryMuscles: [String]
  public var secondaryMuscles: [String]
  public var instructions: [String]
  public var imageUrls: [String]
  
  init(category: String, equipment: String? = nil, force: String? = nil, id: UUID? = nil, level: String, name: String, primaryMuscles: [String], secondaryMuscles: [String], instructions: [String], imageUrls: [String]) {
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

  enum CodingKeys: String, CodingKey {
    case category, equipment, force, id, level, name, primaryMuscles, secondaryMuscles, instructions, imageUrls
  }
  
  func getImagesURLs() -> [URL] {
    return imageUrls.compactMap { imageUrlString in
      URL(string: imageUrlString)
    }
  }
  
  private var wrappedId: NSUUID {
    return self.id! as NSUUID
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
  
  public static func ==(_ lhs: Exercise, rhs: Exercise) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Exercise: DecodableModel { }

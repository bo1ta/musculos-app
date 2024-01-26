//
//  Exercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.09.2023.
//

import Foundation
import CoreData

struct Exercise: Codable {
  var bodyPart: String
  var equipment: String
  var gifUrl: String
  var id: String
  var name: String
  var target: String
  var secondaryMuscles: [String]
  var instructions: [String]
  
  enum CodingKeys: String, CodingKey {
    case id
    case bodyPart = "body_part"
    case equipment
    case gifUrl = "gif_url"
    case name
    case target
    case secondaryMuscles = "secondary_muscles"
    case instructions
  }
}

extension Exercise: DecodableModel {
  init(from entity: ExerciseManagedObject) {
    self.id = entity.id
    self.name = entity.name
    self.target = entity.target
    self.bodyPart = entity.bodyPart
    self.equipment = entity.equipment
    self.gifUrl = entity.gifUrl

    if let secondaryMuscles = entity.secondaryMuscles as? Set<StringHolder> {
      self.secondaryMuscles = secondaryMuscles.map { $0.string }
    } else {
      self.secondaryMuscles = []
    }

    if let instructions = entity.instructions as? Set<StringHolder> {
      self.instructions = instructions.map { $0.string }
    } else {
      self.instructions = []
    }
  }

  @discardableResult func toEntity(context: NSManagedObjectContext) -> ExerciseManagedObject {
    let entity = ExerciseManagedObject(context: context)
    entity.bodyPart = self.bodyPart
    entity.equipment = self.equipment
    entity.gifUrl = self.gifUrl
    entity.id = self.id
    entity.name = self.name
    entity.target = self.target
    entity.secondaryMuscles = toEntitySet(strings: self.secondaryMuscles, context: context) as NSSet
    entity.instructions = toEntitySet(strings: self.instructions, context: context) as NSSet
    entity.isFavorite = false
    return entity
  }

  private func toEntitySet(strings: [String], context: NSManagedObjectContext) -> Set<StringHolder> {
    return Set(strings.map { string in
      let stringHolderEntity = StringHolder(context: context)
      stringHolderEntity.string = string
      return stringHolderEntity
    })
  }
}

extension Exercise: Identifiable { }

extension Exercise: Hashable {
  func hash(into hasher: inout Hasher) {
    hasher.combine(self.id)
  }
}

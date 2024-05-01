//
//  ExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//
//

import Foundation
import CoreData

extension ExerciseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
    return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
  }
  
  @NSManaged public var category: String?
  @NSManaged public var equipment: String?
  @NSManaged public var force: String?
  @NSManaged public var exerciseId: UUID?
  @NSManaged public var imageUrls: [String]?
  @NSManaged public var instructions: [String]?
  @NSManaged public var isFavorite: Bool
  @NSManaged public var level: String?
  @NSManaged public var name: String?
  @NSManaged public var primaryMuscles: [String]
  @NSManaged public var secondaryMuscles: [String]
  @NSManaged public var workouts: Set<WorkoutEntity>
}

extension ExerciseEntity : Identifiable {}

// MARK: - ReadOnlyConvertible impl

extension ExerciseEntity: ReadOnlyConvertible {
  func toReadOnly() -> Exercise {
    return Exercise(
      category: self.category ?? "",
      equipment: self.equipment,
      id: self.exerciseId!,
      level: self.level!,
      name: self.name!,
      primaryMuscles: self.primaryMuscles,
      secondaryMuscles: self.secondaryMuscles,
      instructions: self.instructions!,
      imageUrls: self.imageUrls!
    )
  }
}

// MARK: - Common Predicate

extension ExerciseEntity {
  enum CommonPredicate {
    case byId(UUID)
    case byName(String)
    case isFavorite
    
    var nsPredicate: NSPredicate {
      switch self {
      case .byId(let uuid):
        return NSPredicate(
          format: "%K == %@",
          #keyPath(ExerciseEntity.exerciseId),
          uuid as NSUUID
        )
      case .byName(let name):
        return NSPredicate(
          format: "%K CONTAINS %@",
          #keyPath(ExerciseEntity.name),
          name
        )
      case .isFavorite:
        return NSPredicate(
          format: "%K == true",
          #keyPath(ExerciseEntity.isFavorite)
        )
      }
    }
  }
}

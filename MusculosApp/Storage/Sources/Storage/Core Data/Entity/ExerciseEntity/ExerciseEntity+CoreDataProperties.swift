//
//  ExerciseEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData
import Models

extension ExerciseEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
    return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
  }
  
  @NSManaged public var category: String?
  @NSManaged public var equipment: String?
  @NSManaged public var exerciseId: UUID?
  @NSManaged public var force: String?
  @NSManaged public var imageUrls: [String]?
  @NSManaged public var instructions: [String]?
  @NSManaged public var isFavorite: Bool
  @NSManaged public var level: String?
  @NSManaged public var name: String?
  @NSManaged public var primaryMuscles: Set<PrimaryMuscleEntity>
  @NSManaged public var secondaryMuscles: Set<SecondaryMuscleEntity>
  @NSManaged public var exerciseSessions: Set<ExerciseSessionEntity>
}

// MARK: Generated accessors for primaryMuscles
extension ExerciseEntity {
  
  @objc(addPrimaryMusclesObject:)
  @NSManaged public func addToPrimaryMuscles(_ value: PrimaryMuscleEntity)
  
  @objc(removePrimaryMusclesObject:)
  @NSManaged public func removeFromPrimaryMuscles(_ value: PrimaryMuscleEntity)
  
  @objc(addPrimaryMuscles:)
  @NSManaged public func addToPrimaryMuscles(_ values: Set<PrimaryMuscleEntity>)
  
  @objc(removePrimaryMuscles:)
  @NSManaged public func removeFromPrimaryMuscles(_ values: Set<PrimaryMuscleEntity>)
}

// MARK: Generated accessors for secondaryMuscles
extension ExerciseEntity {
  
  @objc(addSecondaryMusclesObject:)
  @NSManaged public func addToSecondaryMuscles(_ value: SecondaryMuscleEntity)
  
  @objc(removeSecondaryMusclesObject:)
  @NSManaged public func removeFromSecondaryMuscles(_ value: SecondaryMuscleEntity)
  
  @objc(addSecondaryMuscles:)
  @NSManaged public func addToSecondaryMuscles(_ values: NSSet)
  
  @objc(removeSecondaryMuscles:)
  @NSManaged public func removeFromSecondaryMuscles(_ values: NSSet)
}

// MARK: Generated accessors for exerciseSessions
extension ExerciseEntity {
  
  @objc(addExerciseSessionsObject:)
  @NSManaged public func addToExerciseSessions(_ value: ExerciseSessionEntity)
  
  @objc(removeFromExerciseSessions:)
  @NSManaged public func removeFromExerciseSessions(_ value: ExerciseSessionEntity)
  
  @objc(addExerciseSessions:)
  @NSManaged public func addToExerciseSessions(_ values: NSSet)
  
  @objc(removeExerciseSessions:)
  @NSManaged public func removeFromExerciseSessions(_ values: NSSet)
}

extension ExerciseEntity : Identifiable { }

// MARK: - ReadOnlyConvertible impl

extension ExerciseEntity: ReadOnlyConvertible {
  func toReadOnly() -> Exercise {
    let primaryMuscles = Array(primaryMuscles).compactMap { $0.toReadOnly() }
    let secondaryMuscles = Array(secondaryMuscles).compactMap { $0.toReadOnly() }
    
    return Exercise(
      category: self.category ?? "",
      equipment: self.equipment,
      id: self.exerciseId!,
      level: self.level!,
      name: self.name!,
      primaryMuscles: primaryMuscles,
      secondaryMuscles: secondaryMuscles,
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

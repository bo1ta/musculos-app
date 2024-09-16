//
//  ExerciseEntity+CoreDataClass.swift
//  Storage
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData
import Models
import Utility

@objc(ExerciseEntity)
public final class ExerciseEntity: NSManagedObject {
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
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
    return NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
  }
  
  /// Populate default fields where is needed
  ///
  public override func awakeFromInsert() {
    super.awakeFromInsert()
    
    self.exerciseSessions = Set<ExerciseSessionEntity>()
  }
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

// MARK: - ReadOnlyConvertible

extension ExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Exercise {
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

// MARK: - EntitySyncable

extension ExerciseEntity: EntitySyncable {
  public func populateEntityFrom(_ model: Exercise, using storage: StorageType) throws {
    self.category = model.category
    self.exerciseId = model.id
    self.category = model.category
    self.equipment = model.equipment
    self.level = model.level
    self.name = model.name
    self.instructions = model.instructions
    self.imageUrls = model.imageUrls
    self.isFavorite = model.isFavorite ?? false
    self.primaryMuscles = PrimaryMuscleEntity.createFor(exerciseEntity: self, from: model.primaryMuscles, using: storage)
    self.secondaryMuscles = SecondaryMuscleEntity.createFor(exerciseEntity: self, from: model.secondaryMuscles, using: storage)
  }

  public func updateEntityFrom(_ model: Exercise, using storage: StorageType) throws {
    guard let isFavorite = model.isFavorite else { return }

    self.isFavorite = isFavorite
  }
}

//
//  ExerciseEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import CoreData
import Foundation
import Models
import Utility

// MARK: - ExerciseEntity

@objc(ExerciseEntity)
public final class ExerciseEntity: NSManagedObject {
  @NSManaged public var category: String?
  @NSManaged public var equipment: String?
  @NSManaged public var exerciseId: UUID
  @NSManaged public var force: String?
  @NSManaged public var imageUrls: [String]?
  @NSManaged public var instructions: [String]?
  @NSManaged public var isFavorite: Bool
  @NSManaged public var level: String?
  @NSManaged public var name: String?
  @NSManaged public var primaryMuscles: Set<PrimaryMuscleEntity>
  @NSManaged public var secondaryMuscles: Set<SecondaryMuscleEntity>
  @NSManaged public var exerciseSessions: Set<ExerciseSessionEntity>
  @NSManaged public var ratings: Set<ExerciseRatingEntity>
  @NSManaged public var updatedAt: Date?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ExerciseEntity> {
    NSFetchRequest<ExerciseEntity>(entityName: "ExerciseEntity")
  }

  /// Populate default fields where is needed
  ///
  override public func awakeFromInsert() {
    super.awakeFromInsert()

    exerciseSessions = Set<ExerciseSessionEntity>()
  }
}

// MARK: Generated accessors for primaryMuscles

extension ExerciseEntity {
  @objc(addPrimaryMusclesObject:)
  @NSManaged
  public func addToPrimaryMuscles(_ value: PrimaryMuscleEntity)

  @objc(removePrimaryMusclesObject:)
  @NSManaged
  public func removeFromPrimaryMuscles(_ value: PrimaryMuscleEntity)

  @objc(addPrimaryMuscles:)
  @NSManaged
  public func addToPrimaryMuscles(_ values: Set<PrimaryMuscleEntity>)

  @objc(removePrimaryMuscles:)
  @NSManaged
  public func removeFromPrimaryMuscles(_ values: Set<PrimaryMuscleEntity>)
}

// MARK: Generated accessors for secondaryMuscles

extension ExerciseEntity {
  @objc(addSecondaryMusclesObject:)
  @NSManaged
  public func addToSecondaryMuscles(_ value: SecondaryMuscleEntity)

  @objc(removeSecondaryMusclesObject:)
  @NSManaged
  public func removeFromSecondaryMuscles(_ value: SecondaryMuscleEntity)

  @objc(addSecondaryMuscles:)
  @NSManaged
  public func addToSecondaryMuscles(_ values: NSSet)

  @objc(removeSecondaryMuscles:)
  @NSManaged
  public func removeFromSecondaryMuscles(_ values: NSSet)
}

// MARK: Generated accessors for exerciseSessions

extension ExerciseEntity {
  @objc(addExerciseSessionsObject:)
  @NSManaged
  public func addToExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(removeFromExerciseSessions:)
  @NSManaged
  public func removeFromExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(addExerciseSessions:)
  @NSManaged
  public func addToExerciseSessions(_ values: NSSet)

  @objc(removeExerciseSessions:)
  @NSManaged
  public func removeFromExerciseSessions(_ values: NSSet)
}

// MARK: Generated accessors for exerciseRatings

extension ExerciseEntity {
  @objc(addExerciseRatingsObject:)
  @NSManaged
  public func addToExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(removeFromExerciseRatings:)
  @NSManaged
  public func removeFromExerciseRatings(_ value: ExerciseSessionEntity)

  @objc(addExerciseRatings:)
  @NSManaged
  public func addToExerciseRatings(_ values: NSSet)

  @objc(removeExerciseRatings:)
  @NSManaged
  public func removeFromExerciseRatings(_ values: NSSet)
}

// MARK: Identifiable

extension ExerciseEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension ExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> Exercise {
    let primaryMuscles = Array(primaryMuscles).compactMap { $0.toReadOnly() }
    let secondaryMuscles = Array(secondaryMuscles).compactMap { $0.toReadOnly() }

    return Exercise(
      category: category ?? "",
      equipment: equipment,
      id: exerciseId,
      level: level ?? "",
      name: name ?? "",
      primaryMuscles: primaryMuscles,
      secondaryMuscles: secondaryMuscles,
      instructions: instructions ?? [],
      imageUrls: imageUrls ?? [],
      isFavorite: isFavorite,
      updatedAt: updatedAt,
      ratings: ratings.map { $0.toReadOnly() }
    )
  }
}

// MARK: EntitySyncable

extension ExerciseEntity: EntitySyncable {
  public func populateEntityFrom(_ model: Exercise, using storage: StorageType) {
    exerciseId = model.id
    category = model.category
    category = model.category
    equipment = model.equipment
    level = model.level
    name = model.name
    instructions = model.instructions
    imageUrls = model.imageUrls
    isFavorite = model.isFavorite ?? false
    primaryMuscles = PrimaryMuscleEntity.createFor(exerciseEntity: self, from: model.primaryMuscles, using: storage)
    secondaryMuscles = SecondaryMuscleEntity.createFor(exerciseEntity: self, from: model.secondaryMuscles, using: storage)
    updatedAt = model.updatedAt ?? Date()
  }

  public func updateEntityFrom(_ model: Exercise, using _: StorageType) {
    guard let isFavorite = model.isFavorite else {
      return
    }

    self.isFavorite = isFavorite
    updatedAt = Date()
  }

  static func findOrCreate(from model: Exercise, using storage: StorageType) -> ExerciseEntity {
    if let exerciseEntity = storage.firstObject(of: ExerciseEntity.self, matching: PredicateProvider.exerciseById(model.id)) {
      return exerciseEntity
    }

    let exerciseEntity = storage.insertNewObject(ofType: ExerciseEntity.self)
    exerciseEntity.populateEntityFrom(model, using: storage)
    return exerciseEntity
  }
}

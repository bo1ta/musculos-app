//
//  SecondaryMuscleEntity.swift
//
//
//  Created by Solomon Alexandru on 12.12.2024.
//
//

import CoreData
import Foundation
import Models

// MARK: - SecondaryMuscleEntity

@objc(SecondaryMuscleEntity)
public class SecondaryMuscleEntity: MuscleEntity {
  @NSManaged public var exercises: Set<ExerciseEntity>

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<SecondaryMuscleEntity> {
    NSFetchRequest<SecondaryMuscleEntity>(entityName: "SecondaryMuscleEntity")
  }

  static func createFor(
    exerciseEntity: ExerciseEntity,
    from muscles: [String],
    using storage: StorageType)
    -> Set<SecondaryMuscleEntity>
  {
    Set<SecondaryMuscleEntity>(
      muscles
        .compactMap { muscle -> SecondaryMuscleEntity? in
          guard let muscleType = MuscleType(rawValue: muscle) else {
            return nil
          }

          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(SecondaryMuscleEntity.muscleID),
            muscleType.id)

          if let entity = storage.firstObject(of: SecondaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = storage.insertNewObject(ofType: SecondaryMuscleEntity.self)
            entity.muscleID = muscleType.id as NSNumber
            entity.name = muscleType.rawValue
            entity.exercises.insert(exerciseEntity)
            return entity
          }
        })
  }
}

// MARK: Generated accessors for exercises

extension SecondaryMuscleEntity {
  @objc(addExercisesObject:)
  @NSManaged
  public func addToExercises(_ value: ExerciseEntity)

  @objc(removeExercisesObject:)
  @NSManaged
  public func removeFromExercises(_ value: ExerciseEntity)

  @objc(addExercises:)
  @NSManaged
  public func addToExercises(_ values: Set<ExerciseEntity>)

  @objc(removeExercises:)
  @NSManaged
  public func removeFromExercises(_ values: Set<ExerciseEntity>)
}

// MARK: Identifiable

extension SecondaryMuscleEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension SecondaryMuscleEntity: ReadOnlyConvertible {
  public func toReadOnly() -> String {
    name
  }
}

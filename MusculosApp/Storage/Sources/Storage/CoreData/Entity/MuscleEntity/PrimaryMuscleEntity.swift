//
//  PrimaryMuscleEntity.swift
//
//
//  Created by Solomon Alexandru on 12.12.2024.
//
//

import CoreData
import Foundation
import Models

// MARK: - PrimaryMuscleEntity

@objc(PrimaryMuscleEntity)
public class PrimaryMuscleEntity: MuscleEntity {
  @NSManaged public var exercises: Set<ExerciseEntity>

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<PrimaryMuscleEntity> {
    NSFetchRequest<PrimaryMuscleEntity>(entityName: "PrimaryMuscleEntity")
  }

  static func createFor(
    exerciseEntity: ExerciseEntity,
    from muscles: [String],
    using storage: StorageType)
    -> Set<PrimaryMuscleEntity>
  {
    Set<PrimaryMuscleEntity>(
      muscles
        .compactMap { muscle -> PrimaryMuscleEntity? in
          guard let muscleType = MuscleType(rawValue: muscle) else {
            return nil
          }

          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(PrimaryMuscleEntity.muscleID),
            muscleType.id)

          if let entity = storage.firstObject(of: PrimaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = storage.insertNewObject(ofType: PrimaryMuscleEntity.self)
            entity.muscleID = muscleType.id as NSNumber
            entity.name = muscleType.rawValue
            entity.exercises.insert(exerciseEntity)
            return entity
          }
        })
  }
}

// MARK: Generated accessors for exercises

extension PrimaryMuscleEntity {
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

extension PrimaryMuscleEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension PrimaryMuscleEntity: ReadOnlyConvertible {
  public func toReadOnly() -> String {
    name
  }
}

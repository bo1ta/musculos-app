//
//  SecondaryMuscleEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.05.2024.
//
//

import Foundation
import CoreData
import Models

@objc(SecondaryMuscleEntity)
public class SecondaryMuscleEntity: NSManagedObject {
  @NSManaged public var muscleId: NSNumber
  @NSManaged public var name: String
  @NSManaged public var exercises: Set<ExerciseEntity>

  @nonobjc public class func fetchRequest() -> NSFetchRequest<SecondaryMuscleEntity> {
    return NSFetchRequest<SecondaryMuscleEntity>(entityName: "SecondaryMuscleEntity")
  }

  static func createFor(exerciseEntity: ExerciseEntity, from muscles: [String], using storage: StorageType) -> Set<SecondaryMuscleEntity> {
    return Set<SecondaryMuscleEntity>(
      muscles
        .compactMap { muscle -> SecondaryMuscleEntity? in
          guard let muscleType = MuscleType(rawValue: muscle) else { return nil }

          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(SecondaryMuscleEntity.muscleId),
            muscleType.id
          )

          if let entity = storage.firstObject(of: SecondaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = storage.insertNewObject(ofType: SecondaryMuscleEntity.self)
            entity.muscleId = NSNumber(integerLiteral: muscleType.id)
            entity.name = muscleType.rawValue
            entity.exercises.insert(exerciseEntity)
            return entity
          }
        }
    )
  }
}

// MARK: Generated accessors for exercises
extension SecondaryMuscleEntity {
  @objc(addExercisesObject:)
  @NSManaged public func addToExercises(_ value: ExerciseEntity)

  @objc(removeExercisesObject:)
  @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

  @objc(addExercises:)
  @NSManaged public func addToExercises(_ values: Set<ExerciseEntity>)

  @objc(removeExercises:)
  @NSManaged public func removeFromExercises(_ values: Set<ExerciseEntity>)
}

extension SecondaryMuscleEntity : Identifiable { }

extension SecondaryMuscleEntity: ReadOnlyConvertible {
  public func toReadOnly() -> String {
    return name
  }
}

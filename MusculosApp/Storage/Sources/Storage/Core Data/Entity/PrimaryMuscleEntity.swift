//
//  PrimaryMuscleEntity.swift
//  
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import Foundation
import CoreData
import Models

@objc(PrimaryMuscleEntity)
public class PrimaryMuscleEntity: NSManagedObject {
  @NSManaged public var muscleId: NSNumber
  @NSManaged public var name: String
  @NSManaged public var exercises: Set<ExerciseEntity>

  @nonobjc public class func fetchRequest() -> NSFetchRequest<PrimaryMuscleEntity> {
    return NSFetchRequest<PrimaryMuscleEntity>(entityName: "PrimaryMuscleEntity")
  }

  static func createFor(exerciseEntity: ExerciseEntity, from muscles: [String], using storage: StorageType) -> Set<PrimaryMuscleEntity> {
    return Set<PrimaryMuscleEntity>(
      muscles
        .compactMap { muscle -> PrimaryMuscleEntity? in
          guard let muscleType = MuscleType(rawValue: muscle) else { return nil }

          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(PrimaryMuscleEntity.muscleId),
            muscleType.id
          )

          if let entity = storage.firstObject(of: PrimaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = storage.insertNewObject(ofType: PrimaryMuscleEntity.self)
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
extension PrimaryMuscleEntity {
  @objc(addExercisesObject:)
  @NSManaged public func addToExercises(_ value: ExerciseEntity)

  @objc(removeExercisesObject:)
  @NSManaged public func removeFromExercises(_ value: ExerciseEntity)

  @objc(addExercises:)
  @NSManaged public func addToExercises(_ values: Set<ExerciseEntity>)

  @objc(removeExercises:)
  @NSManaged public func removeFromExercises(_ values: Set<ExerciseEntity>)
}

extension PrimaryMuscleEntity : Identifiable { }

extension PrimaryMuscleEntity: ReadOnlyConvertible {
  public func toReadOnly() -> String {
    return self.name
  }
}

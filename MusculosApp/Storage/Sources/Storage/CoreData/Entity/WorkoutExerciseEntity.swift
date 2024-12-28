//
//  WorkoutExerciseEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import Foundation
import CoreData
import Models

@objc(WorkoutExerciseEntity)
class WorkoutExerciseEntity: NSManagedObject {
  @NSManaged public var modelID: UUID
  @NSManaged public var numberOfReps: NSNumber
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var workout: WorkoutEntity?

  @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutExerciseEntity> {
    return NSFetchRequest<WorkoutExerciseEntity>(entityName: "WorkoutExerciseEntity")
  }
}

extension WorkoutExerciseEntity : Identifiable { }

extension WorkoutExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> WorkoutExercise {
    return WorkoutExercise(
      id: modelID,
      numberOfReps: self.numberOfReps.intValue,
      exercise: exercise.toReadOnly()
    )
  }
}

extension WorkoutExerciseEntity: EntitySyncable {
  func populateEntityFrom(_ model: WorkoutExercise, using storage: any StorageType) {
    modelID = model.id
    numberOfReps = NSNumber(value: model.numberOfReps)
    exercise = ExerciseEntity.findOrCreate(from: model.exercise, using: storage)
  }

  func updateEntityFrom(_ model: WorkoutExercise, using storage: any StorageType) {
    numberOfReps = NSNumber(value: model.numberOfReps)
  }
}

extension WorkoutExerciseEntity {
  static func findOrCreate(_ model: WorkoutExercise, using storage: StorageType) -> WorkoutExerciseEntity {
    if let entity = storage.firstObject(of: WorkoutExerciseEntity.self, matching: model.matchingPredicate()) {
      return entity
    }

    let entity = storage.insertNewObject(ofType: WorkoutExerciseEntity.self)
    entity.populateEntityFrom(model, using: storage)
    return entity
  }
}

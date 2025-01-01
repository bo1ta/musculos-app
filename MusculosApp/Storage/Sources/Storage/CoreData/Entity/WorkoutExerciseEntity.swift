//
//  WorkoutExerciseEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//
//

import CoreData
import Foundation
import Models

// MARK: - WorkoutExerciseEntity

@objc(WorkoutExerciseEntity)
class WorkoutExerciseEntity: NSManagedObject {
  @NSManaged var modelID: UUID
  @NSManaged var numberOfReps: NSNumber
  @NSManaged var exercise: ExerciseEntity
  @NSManaged var workout: WorkoutEntity?

  @nonobjc
  class func fetchRequest() -> NSFetchRequest<WorkoutExerciseEntity> {
    NSFetchRequest<WorkoutExerciseEntity>(entityName: "WorkoutExerciseEntity")
  }
}

// MARK: Identifiable

extension WorkoutExerciseEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension WorkoutExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> WorkoutExercise {
    WorkoutExercise(
      id: modelID,
      numberOfReps: numberOfReps.intValue,
      exercise: exercise.toReadOnly())
  }
}

// MARK: EntitySyncable

extension WorkoutExerciseEntity: EntitySyncable {
  func populateEntityFrom(_ model: WorkoutExercise, using storage: any StorageType) {
    modelID = model.id
    numberOfReps = NSNumber(value: model.numberOfReps)
    exercise = ExerciseEntity.findOrCreate(from: model.exercise, using: storage)
  }

  func updateEntityFrom(_ model: WorkoutExercise, using _: any StorageType) {
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

//
//  WorkoutExerciseEntity+CoreDataClass.swift
//
//
//  Created by Solomon Alexandru on 20.01.2025.
//
//

import CoreData
import Foundation
import Models

// MARK: - WorkoutExerciseEntity

@objc(WorkoutExerciseEntity)
public class WorkoutExerciseEntity: NSManagedObject {
  @NSManaged public var uniqueID: UUID
  @NSManaged public var numberOfReps: NSNumber
  @NSManaged public var minValue: NSNumber
  @NSManaged public var maxValue: NSNumber
  @NSManaged public var isCompleted: Bool
  @NSManaged public var measurement: String
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var dailyWorkout: DailyWorkoutEntity

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<WorkoutExerciseEntity> {
    NSFetchRequest<WorkoutExerciseEntity>(entityName: "WorkoutExerciseEntity")
  }
}

// MARK: ReadOnlyConvertible

extension WorkoutExerciseEntity: ReadOnlyConvertible {
  public func toReadOnly() -> WorkoutExercise {
    WorkoutExercise(
      id: uniqueID,
      numberOfReps: numberOfReps.intValue,
      exercise: exercise.toReadOnly(),
      isCompleted: isCompleted,
      measurement: ExerciseMeasurement(rawValue: measurement) ?? .reps,
      minValue: minValue.intValue,
      maxValue: maxValue.intValue)
  }
}

// MARK: EntitySyncable

extension WorkoutExerciseEntity: EntitySyncable {
  public func populateEntityFrom(_ model: WorkoutExercise, using storage: any StorageType) {
    uniqueID = model.id
    numberOfReps = model.numberOfReps as NSNumber
    isCompleted = model.isCompleted
    measurement = model.measurement.rawValue
    minValue = model.minValue as NSNumber
    maxValue = model.maxValue as NSNumber
    exercise = ExerciseEntity.findOrCreate(from: model.exercise, using: storage)
  }

  public func updateEntityFrom(_ model: WorkoutExercise, using _: any StorageType) {
    isCompleted = model.isCompleted
  }
}

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

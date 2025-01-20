//
//  DailyWorkoutEntity.swift
//
//
//  Created by Solomon Alexandru on 20.01.2025.
//
//

import CoreData
import Foundation
import Models

// MARK: - DailyWorkoutEntity

@objc(DailyWorkoutEntity)
public class DailyWorkoutEntity: NSManagedObject {
  @NSManaged public var uniqueID: UUID
  @NSManaged public var dayNumber: NSNumber
  @NSManaged public var isRestDay: Bool
  @NSManaged public var workoutExercises: Set<WorkoutExerciseEntity>
  @NSManaged public var workoutChallenge: WorkoutChallengeEntity?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<DailyWorkoutEntity> {
    NSFetchRequest<DailyWorkoutEntity>(entityName: "DailyWorkoutEntity")
  }
}

// MARK: Generated accessors for workoutExercises
extension DailyWorkoutEntity {

  @objc(addWorkoutExercisesObject:)
  @NSManaged
  public func addToWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(removeWorkoutExercisesObject:)
  @NSManaged
  public func removeFromWorkoutExercises(_ value: WorkoutExerciseEntity)

  @objc(addWorkoutExercises:)
  @NSManaged
  public func addToWorkoutExercises(_ values: NSSet)

  @objc(removeWorkoutExercises:)
  @NSManaged
  public func removeFromWorkoutExercises(_ values: NSSet)
}

// MARK: ReadOnlyConvertible

extension DailyWorkoutEntity: ReadOnlyConvertible {
  public func toReadOnly() -> DailyWorkout {
    let workoutExercises = workoutExercises.map { $0.toReadOnly() }
    return DailyWorkout(id: uniqueID, dayNumber: dayNumber.intValue, exercises: workoutExercises, isRestDay: isRestDay)
  }
}

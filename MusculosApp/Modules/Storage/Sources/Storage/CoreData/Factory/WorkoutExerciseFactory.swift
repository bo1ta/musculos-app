//
//  WorkoutExerciseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 20.01.2025.
//

import Foundation
import Models

public final class WorkoutExerciseFactory: BaseFactory, @unchecked Sendable {
  public var isPersistent = true

  public var id: UUID?
  public var numberOfReps: Int?
  public var minValue: Int?
  public var maxValue: Int?
  public var exercise: Exercise?
  public var isCompleted: Bool?
  public var measurement: ExerciseMeasurement?

  public func create() -> WorkoutExercise {
    let model = WorkoutExercise(
      id: id ?? UUID(),
      numberOfReps: numberOfReps ?? faker.number.randomInt(min: 4, max: 15),
      exercise: exercise ?? ExerciseFactory.createExercise(),
      isCompleted: isCompleted ?? false,
      measurement: measurement ?? ExerciseMeasurement.reps,
      minValue: minValue ?? 3,
      maxValue: maxValue ?? 10)
    syncObject(model, of: WorkoutExerciseEntity.self)
    return model
  }

  public static func createWorkoutExercise() -> WorkoutExercise {
    WorkoutExerciseFactory().create()
  }
}

//
//  DailyWorkoutFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 20.01.2025.
//

import Foundation
import Models

public final class DailyWorkoutFactory: BaseFactory, @unchecked Sendable {
  public var isPersistent = true

  public var id: UUID?
  public var dayNumber: Int?
  public var workoutExercises: [WorkoutExercise]?
  public var isRestDay: Bool?

  public func create() -> DailyWorkout {
    let model = DailyWorkout(
      id: id ?? UUID(),
      dayNumber: dayNumber ?? faker.number.randomInt(min: 0, max: 30),
      exercises: workoutExercises ?? [WorkoutExerciseFactory.createWorkoutExercise()],
      isRestDay: isRestDay ?? false)
    syncObject(model, of: DailyWorkoutEntity.self)
    return model
  }

  public static func createDailyWorkout() -> DailyWorkout {
    DailyWorkoutFactory().create()
  }
}

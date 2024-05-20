//
//  WorkoutFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 17.05.2024.
//

import Foundation

struct WorkoutFactory {
  static func create(name: String = "Intense Chest Workout") -> Workout {
    var workoutExercises: [WorkoutExercise] = []
    for i in 1...Int.random(in: 2...5) {
      let numberOfReps = Int.random(in: 1...5)
      let exerciseName = "Exercise no\(i)"
      let workoutExercise = WorkoutExercise(numberOfReps: numberOfReps, exercise: ExerciseFactory.createExercise(name: name))
      workoutExercises.append(workoutExercise)
    }
    
    return Workout(
      name: name,
      targetMuscles: [
        MuscleType.chest.rawValue
      ],
      workoutType: "gym",
      workoutExercises: workoutExercises
    )
  }
}

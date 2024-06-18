//
//  WorkoutExercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

struct WorkoutExercise: Codable {
  let numberOfReps: Int
  let exercise: Exercise
}

extension WorkoutExercise: Hashable {
  static func ==(_ lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
    return lhs.exercise.id == rhs.exercise.id
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(numberOfReps)
    hasher.combine(exercise.id)
  }
}

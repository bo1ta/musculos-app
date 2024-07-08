//
//  Workout.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

struct Workout {
  let name: String
  let targetMuscles: [String]
  let workoutType: String
  let createdBy: User?
  let workoutExercises: [WorkoutExercise]
  
  init(name: String, targetMuscles: [String], workoutType: String, createdBy: User? = nil, workoutExercises: [WorkoutExercise]) {
    self.name = name
    self.targetMuscles = targetMuscles
    self.workoutType = workoutType
    self.createdBy = createdBy
    self.workoutExercises = workoutExercises
  }
}

extension Workout: Hashable {
  static func ==(_ lhs: Workout, rhs: Workout) -> Bool {
    return lhs.name == rhs.name && lhs.workoutType == rhs.workoutType
  }
  
  func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(workoutType)
  }
}

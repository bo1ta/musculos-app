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
  let createdBy: Person?
  let workoutExercises: [WorkoutExercise]
  
  init(name: String, targetMuscles: [String], workoutType: String, createdBy: Person? = nil, workoutExercises: [WorkoutExercise]) {
    self.name = name
    self.targetMuscles = targetMuscles
    self.workoutType = workoutType
    self.createdBy = createdBy
    self.workoutExercises = workoutExercises
  }
}
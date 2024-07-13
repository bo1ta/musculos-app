//
//  Workout.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

public struct Workout: Sendable {
  public let name: String
  public let targetMuscles: [String]
  public let workoutType: String
  public let createdBy: UserProfile?
  public let workoutExercises: [WorkoutExercise]
  
  public init(name: String, targetMuscles: [String], workoutType: String, createdBy: UserProfile? = nil, workoutExercises: [WorkoutExercise]) {
    self.name = name
    self.targetMuscles = targetMuscles
    self.workoutType = workoutType
    self.createdBy = createdBy
    self.workoutExercises = workoutExercises
  }
}

extension Workout: Hashable {
  public static func ==(_ lhs: Workout, rhs: Workout) -> Bool {
    return lhs.name == rhs.name && lhs.workoutType == rhs.workoutType
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(workoutType)
  }
}

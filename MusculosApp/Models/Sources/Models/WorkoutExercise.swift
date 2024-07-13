//
//  WorkoutExercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

public struct WorkoutExercise: Codable, Sendable {
  public let numberOfReps: Int
  public let exercise: Exercise
  
  public init(numberOfReps: Int, exercise: Exercise) {
    self.numberOfReps = numberOfReps
    self.exercise = exercise
  }
}

extension WorkoutExercise: Hashable {
  public static func ==(_ lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
    return lhs.exercise.id == rhs.exercise.id
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(numberOfReps)
    hasher.combine(exercise.id)
  }
}

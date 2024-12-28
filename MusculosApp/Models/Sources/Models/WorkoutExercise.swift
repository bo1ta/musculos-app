//
//  WorkoutExercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

public struct WorkoutExercise: Codable, Sendable {
  public let id: UUID
  public let numberOfReps: Int
  public let exercise: Exercise
  
  public init(id: UUID = UUID(), numberOfReps: Int, exercise: Exercise) {
    self.id = id
    self.numberOfReps = numberOfReps
    self.exercise = exercise
  }
}

extension WorkoutExercise: Hashable {
  public static func ==(_ lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
    return lhs.id == rhs.id
  }
  
  public func hash(into hasher: inout Hasher) {
    hasher.combine(numberOfReps)
    hasher.combine(exercise.id)
  }
}

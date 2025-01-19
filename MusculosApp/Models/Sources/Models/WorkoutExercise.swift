//
//  WorkoutExercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

// MARK: - WorkoutExercise

public struct WorkoutExercise: Codable, Sendable {
  public let id: UUID
  public let numberOfReps: Int
  public let exercise: Exercise
  public let isCompleted: Bool

  public init(id: UUID = UUID(), numberOfReps: Int, exercise: Exercise, isCompleted: Bool = false) {
    self.id = id
    self.numberOfReps = numberOfReps
    self.exercise = exercise
    self.isCompleted = isCompleted
  }
}

// MARK: Hashable

extension WorkoutExercise: Hashable {
  public static func ==(_ lhs: WorkoutExercise, rhs: WorkoutExercise) -> Bool {
    lhs.id == rhs.id
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(numberOfReps)
    hasher.combine(exercise.id)
  }
}

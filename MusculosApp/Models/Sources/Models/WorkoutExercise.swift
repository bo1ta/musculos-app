//
//  WorkoutExercise.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation
import Utility

// MARK: - ExerciseMeasurement

public enum ExerciseMeasurement: String, Codable, Sendable {
  case reps
  case duration // in seconds
  case distance // in meters
  case lbs
  case minutes
}

// MARK: - WorkoutExercise

public struct WorkoutExercise: Codable, Sendable {
  public let id: UUID
  public let numberOfReps: Int
  public let minValue: Int
  public let maxValue: Int
  public let exercise: Exercise
  public let isCompleted: Bool
  public let measurement: ExerciseMeasurement

  public init(
    id: UUID = UUID(),
    numberOfReps: Int,
    exercise: Exercise,
    isCompleted: Bool = false,
    measurement: ExerciseMeasurement = .reps,
    minValue: Int,
    maxValue: Int)
  {
    self.id = id
    self.numberOfReps = numberOfReps
    self.exercise = exercise
    self.isCompleted = isCompleted
    self.measurement = measurement
    self.minValue = minValue
    self.maxValue = maxValue
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

// MARK: DecodableModel

extension WorkoutExercise: DecodableModel { }

// MARK: IdentifiableEntity

extension WorkoutExercise: IdentifiableEntity { }

//
//  Workout.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.04.2024.
//

import Foundation

// MARK: - Workout

public struct Workout: Sendable, Identifiable {
  public let id: UUID
  public let name: String
  public let targetMuscles: [String]
  public let workoutType: String
  public let createdBy: UserProfile
  public let workoutExercises: [WorkoutExercise]

  public init(
    id: UUID = UUID(),
    name: String,
    targetMuscles: [String],
    workoutType: String,
    createdBy: UserProfile,
    workoutExercises: [WorkoutExercise])
  {
    self.id = id
    self.name = name
    self.targetMuscles = targetMuscles
    self.workoutType = workoutType
    self.createdBy = createdBy
    self.workoutExercises = workoutExercises
  }
}

// MARK: Hashable

extension Workout: Hashable {
  public static func ==(_ lhs: Workout, rhs: Workout) -> Bool {
    lhs.name == rhs.name && lhs.workoutType == rhs.workoutType
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(name)
    hasher.combine(workoutType)
  }
}

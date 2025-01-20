//
//  DailyWorkout.swift
//  Models
//
//  Created by Solomon Alexandru on 19.01.2025.
//

import Foundation
import Utility

// MARK: - DailyWorkout

public struct DailyWorkout: Codable, Identifiable, Sendable {
  public let id: UUID
  public let dayNumber: Int
  public let workoutExercises: [WorkoutExercise]
  public var isRestDay: Bool
  public var isCompleted: Bool {
    guard !isRestDay else { return true }
    return workoutExercises.allSatisfy { $0.isCompleted }
  }

  public init(
    id: UUID = UUID(),
    dayNumber: Int,
    exercises: [WorkoutExercise],
    isRestDay: Bool = false)
  {
    self.id = id
    self.dayNumber = dayNumber
    self.workoutExercises = exercises
    self.isRestDay = isRestDay
  }
}

// MARK: DecodableModel

extension DailyWorkout: DecodableModel { }

// MARK: IdentifiableEntity

extension DailyWorkout: IdentifiableEntity { }

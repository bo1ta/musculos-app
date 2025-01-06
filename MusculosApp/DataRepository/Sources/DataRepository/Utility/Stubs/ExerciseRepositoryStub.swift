//
//  ExerciseRepositoryStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Utility

public actor ExerciseRepositoryStub: ExerciseRepositoryProtocol {
  var expectedExercises: [Exercise]

  public init(expectedExercises: [Exercise] = []) {
    self.expectedExercises = expectedExercises
  }

  public func addExercise(_: Exercise) async throws { }

  public func getExercises() async throws -> [Exercise] {
    expectedExercises
  }

  public func getExerciseDetails(for _: UUID) async throws -> Exercise {
    try getFirstExerciseOrThrow()
  }

  public func getExercisesCompletedSinceLastWeek() async throws -> [Exercise] {
    expectedExercises
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    expectedExercises
  }

  public func getExercisesByWorkoutGoal(_: WorkoutGoal) async throws -> [Exercise] {
    expectedExercises
  }

  public func getExercisesForMuscleTypes(_: [MuscleType]) async -> [Exercise] {
    expectedExercises
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    expectedExercises
  }

  public func getRecommendedExercisesByGoals() async -> [Exercise] {
    expectedExercises
  }

  public func searchByQuery(_: String) async throws -> [Exercise] {
    expectedExercises
  }

  public func getByMuscleGroup(_: MuscleGroup) async throws -> [Exercise] {
    expectedExercises
  }

  public func setFavoriteExercise(_: Exercise, isFavorite _: Bool) async throws { }

  private func getFirstExerciseOrThrow() throws -> Exercise {
    if let first = expectedExercises.first {
      return first
    }
    throw MusculosError.unexpectedNil
  }
}
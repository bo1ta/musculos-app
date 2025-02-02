//
//  WorkoutDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import Factory
import Foundation
import Models
import Principle
import Utility

// MARK: - WorkoutDataStoreProtocol

public protocol WorkoutDataStoreProtocol: Sendable {
  func workoutExerciseByID(_ id: UUID) async -> WorkoutExercise?
  func workoutChallengeByID(_ id: UUID) async -> WorkoutChallenge?
  func workout(by id: UUID) async -> Workout?
  func insertWorkout(_ workout: Workout) async throws
  func getAllWorkoutChallenges() async -> [WorkoutChallenge]
  func getRandomWorkoutChallenge() async -> WorkoutChallenge?
}

// MARK: - WorkoutDataStore

public struct WorkoutDataStore: WorkoutDataStoreProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) public var storageManager: StorageManagerType

  public func workoutExerciseByID(_ id: UUID) async -> WorkoutExercise? {
    await storageManager.getFirstEntity(WorkoutExerciseEntity.self, predicate: \WorkoutExerciseEntity.uniqueID == id)
  }

  public func workoutChallengeByID(_ id: UUID) async -> WorkoutChallenge? {
    await storageManager.getFirstEntity(WorkoutChallengeEntity.self, predicate: \WorkoutChallengeEntity.uniqueID == id)
  }

  public func workout(by id: UUID) async -> Workout? {
    let predicate: NSPredicate = \WorkoutEntity.modelID == id
    return await storageManager.getFirstEntity(WorkoutEntity.self, predicate: predicate)
  }

  public func insertWorkout(_ workout: Workout) async throws {
    try await storageManager.importEntity(workout, of: WorkoutEntity.self)
  }

  public func getAllWorkoutChallenges() async -> [WorkoutChallenge] {
    await storageManager.getAllEntities(WorkoutChallengeEntity.self, predicate: nil)
  }

  public func getRandomWorkoutChallenge() async -> WorkoutChallenge? {
    await storageManager.getFirstEntity(WorkoutChallengeEntity.self, predicate: nil)
  }
}

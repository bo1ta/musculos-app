//
//  WorkoutRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 15.01.2025.
//

import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - WorkoutRepositoryProtocol

public protocol WorkoutRepositoryProtocol: Sendable {
  func addWorkout(_ workout: Workout) async throws
  func generateWorkoutChallenge() async throws -> WorkoutChallenge
  func getAllWorkoutChallenges() async throws -> [WorkoutChallenge]
}

// MARK: - WorkoutRepository

public struct WorkoutRepository: @unchecked Sendable, BaseRepository, WorkoutRepositoryProtocol {
  @Injected(\StorageContainer.coreDataStore) var dataStore: CoreDataStore
  @Injected(\NetworkContainer.workoutService) private var service: WorkoutServiceProtocol
  @Injected(\.backgroundWorker) var backgroundWorker: BackgroundWorker

  public func addWorkout(_ workout: Workout) async throws {
    try await dataStore.insertWorkout(workout)
  }

  public func generateWorkoutChallenge() async throws -> WorkoutChallenge {
    try await fetchAndSync(
      remoteTask: { try await service.generateWorkoutChallenge() },
      syncType: WorkoutChallengeEntity.self)
  }

  public func getAllWorkoutChallenges() async throws -> [WorkoutChallenge] {
    try await fetch(
      forType: WorkoutChallengeEntity.self,
      localTask: { await dataStore.getAll(WorkoutChallengeEntity.self) },
      remoteTask: { try await service.getAllWorkoutChallenges() })
  }
}

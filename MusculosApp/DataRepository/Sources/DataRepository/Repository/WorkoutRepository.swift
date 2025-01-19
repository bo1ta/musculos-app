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
}

// MARK: - WorkoutRepository

public struct WorkoutRepository: @unchecked Sendable, BaseRepository, WorkoutRepositoryProtocol {
  @Injected(\StorageContainer.coreDataStore) var dataStore: CoreDataStore

  public func addWorkout(_ workout: Workout) async throws {
    try await dataStore.insertWorkout(workout)
  }
}

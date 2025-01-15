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

public protocol WorkoutRepositoryProtocol: Sendable {
  func addWorkout(_ workout: Workout) async throws
}

public struct WorkoutRepository: @unchecked Sendable, BaseRepository, WorkoutRepositoryProtocol {
  public func addWorkout(_ workout: Workout) async throws {
    try await coreDataStore.insertWorkout(workout)
  }
}

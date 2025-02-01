//
//  ExerciseSessionRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - ExerciseSessionRepositoryProtocol

public protocol ExerciseSessionRepositoryProtocol: Sendable {
  func getExerciseSessions() async throws -> [ExerciseSession]
  func getCompletedSinceLastWeek() async throws -> [ExerciseSession]
  func getCompletedToday() async throws -> [ExerciseSession]
  func addSession(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry
}

// MARK: - ExerciseSessionRepository

public struct ExerciseSessionRepository: @unchecked Sendable, BaseRepository, ExerciseSessionRepositoryProtocol {
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) var dataStore: ExerciseSessionDataStoreProtocol
  @Injected(\.backgroundWorker) var backgroundWorker: BackgroundWorker

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    let userID = try requireCurrentUser()
    return try await fetch(
      forType: ExerciseSessionEntity.self,
      localTask: { await dataStore.exerciseSessionsForUser(userID) },
      remoteTask: { try await service.getAll() })
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    let userID = try requireCurrentUser()
    return await dataStore.exerciseSessionsCompletedSinceLastWeek(for: userID)
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    let userID = try requireCurrentUser()
    return await dataStore.exerciseSessionCompletedToday(for: userID)
  }

  public func addSession(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry {
    let userExperienceEntry = try await service.add(exerciseSession)

    backgroundWorker.queueOperation(priority: .high) {
      try await storageManager.importEntity(exerciseSession, of: ExerciseSessionEntity.self)
      try await storageManager.importEntity(userExperienceEntry, of: UserExperienceEntryEntity.self)
    }

    return userExperienceEntry
  }
}

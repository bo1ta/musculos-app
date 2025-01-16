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
  func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise]
  func getCompletedSinceLastWeek() async throws -> [ExerciseSession]
  func getCompletedToday() async throws -> [ExerciseSession]
  func addSession(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry
}

// MARK: - ExerciseSessionRepository

public struct ExerciseSessionRepository: @unchecked Sendable, BaseRepository, ExerciseSessionRepositoryProtocol {
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return try await fetch(
      forType: ExerciseSessionEntity.self,
      localTask: { await coreDataStore.exerciseSessionsForUser(currentUserID) },
      remoteTask: { try await service.getAll() })
  }

  public func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise] {
    guard let userID = currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return await coreDataStore.exerciseRecommendationsByHistory(for: userID)
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let userID = currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return await coreDataStore.exerciseSessionsCompletedSinceLastWeek(for: userID)
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    guard let userID = currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return await coreDataStore.exerciseSessionCompletedToday(for: userID)
  }

  public func addSession(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry {
    let userExperienceEntry = try await service.add(exerciseSession)

    backgroundWorker.queueOperation(priority: .high) {
      try await coreDataStore.importModel(exerciseSession, of: ExerciseSessionEntity.self)
      try await coreDataStore.importModel(userExperienceEntry, of: UserExperienceEntryEntity.self)
    }

    return userExperienceEntry
  }
}

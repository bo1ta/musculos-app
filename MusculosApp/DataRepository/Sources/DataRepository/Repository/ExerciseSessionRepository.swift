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

public actor ExerciseSessionRepository: BaseRepository {
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    guard await !shouldUseLocalStorageForEntity(ExerciseSessionEntity.self) else {
      return await coreDataStore.exerciseSessionsForUser(currentUserID)
    }

    let exerciseSessions = try await service.getAll()
    syncStorage(exerciseSessions, of: ExerciseSessionEntity.self)
    return exerciseSessions
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

    backgroundWorker.queueOperation(priority: .high) { [weak self] in
      try await self?.coreDataStore.importModel(exerciseSession, of: ExerciseSessionEntity.self)
      try await self?.coreDataStore.importModel(userExperienceEntry, of: UserExperienceEntryEntity.self)
    }

    return userExperienceEntry
  }
}

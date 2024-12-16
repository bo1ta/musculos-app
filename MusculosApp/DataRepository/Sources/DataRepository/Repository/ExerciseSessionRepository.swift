//
//  ExerciseSessionRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Foundation
import Models
import Utility
import Storage
import NetworkClient
import Factory

public actor ExerciseSessionRepository: BaseRepository {
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID = self.currentUserID else {
      throw MusculosError.notFound
    }

    guard await !shouldUseLocalStorageForEntity(ExerciseSessionEntity.self) else {
      return await coreDataStore.exerciseSessionsForUser(currentUserID)
    }

    let exerciseSessions = try await service.getAll()
    syncStorage(exerciseSessions, of: ExerciseSessionEntity.self)
    return exerciseSessions
  }

  public func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await coreDataStore.exerciseRecommendationsByHistory(for: userID)
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await coreDataStore.exerciseSessionsCompletedSinceLastWeek(for: userID)
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await coreDataStore.exerciseSessionCompletedToday(for: userID)
  }

  public func addSession(_ exercise: Exercise, dateAdded: Date, duration: Double, weight: Double) async throws -> UserExperienceEntry {
    guard
      let currentUserID = self.currentUserID,
      let currentProfile = await coreDataStore.userProfile(for: currentUserID)
    else {
      throw MusculosError.notFound
    }

    let exerciseSession = ExerciseSession(
      dateAdded: dateAdded,
      sessionId: UUID(),
      user: currentProfile,
      exercise: exercise,
      duration: duration,
      weight: weight
    )

    let userExperienceEntry = try await service.add(exerciseSession)

    backgroundWorker.queueOperation(priority: .high) { [weak self] in
      try await self?.coreDataStore.importModel(exerciseSession, of: ExerciseSessionEntity.self)
      try await self?.coreDataStore.importModel(userExperienceEntry, of: UserExperienceEntryEntity.self)
    }

    return userExperienceEntry
  }
}

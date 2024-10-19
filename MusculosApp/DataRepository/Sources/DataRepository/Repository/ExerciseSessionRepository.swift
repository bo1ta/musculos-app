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
import Queue

public actor ExerciseSessionRepository: BaseRepository {
  @Injected(\StorageContainer.userManager) private var userSessionManager: UserSessionManagerProtocol
  @Injected(\StorageContainer.userDataStore) private var userDataStore: UserDataStoreProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore: ExerciseSessionDataStoreProtocol
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID = userSessionManager.currentUserID else {
      throw MusculosError.notFound
    }

    guard await !shouldFetchFromLocalStorage() else {
      return await dataStore.getAll(for: currentUserID)
    }

    let exerciseSessions = try await service.getAll()
    backgroundWorker.queueOperation(priority: .medium) { [weak self] in
      try await self?.dataStore.importToStorage(remoteObjects: exerciseSessions, localObjectType: ExerciseSessionEntity.self)
    }
    return exerciseSessions
  }

  public func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise] {
    guard let userID = userSessionManager.currentUserID else {
      throw MusculosError.notFound
    }
    return await dataStore.getRecommendedExercisesBasedOnPastSessions(userID: userID)
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let userID = userSessionManager.currentUserID else {
          throw MusculosError.notFound
    }
    return await dataStore.getCompletedSinceLastWeek(userId: userID)
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    guard let userID = userSessionManager.currentUserID else {
        throw MusculosError.notFound
      }
    return await dataStore.getCompletedToday(userId: userID)
  }

  public func addSession(_ exercise: Exercise, dateAdded: Date, duration: Double) async throws {
    guard
      let currentUserID = userSessionManager.currentUserID,
      let currentProfile = await userDataStore.loadProfile(userId: currentUserID)
    else {
      throw MusculosError.notFound
    }

    let exerciseSession = ExerciseSession(
      dateAdded: dateAdded,
      sessionId: UUID(),
      user: currentProfile,
      exercise: exercise,
      duration: duration
    )

    try await dataStore.addSession(exerciseSession)

    backgroundWorker.queueOperation(priority: .low) { [weak self] in
      try await self?.service.add(exerciseSession)
    }
  }

  private func shouldFetchFromLocalStorage() async -> Bool {
    return await dataStore.getCount() > 0
  }
}

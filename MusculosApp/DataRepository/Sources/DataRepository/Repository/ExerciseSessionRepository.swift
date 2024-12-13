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
  @Injected(\StorageContainer.userDataStore) private var userDataStore: UserDataStoreProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore: ExerciseSessionDataStoreProtocol
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  private let updateThreshold: TimeInterval = .oneDay

  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID = self.currentUserID else {
      throw MusculosError.notFound
    }

    guard await !shouldUseLocalStorage() else {
      return await dataStore.getAll(for: currentUserID)
    }

    let exerciseSessions = try await service.getAll()
    backgroundWorker.queueOperation { [weak self] in
      try await self?.dataStore.importToStorage(models: exerciseSessions, localObjectType: ExerciseSessionEntity.self)
    }
    return exerciseSessions
  }

  public func getRecommendationsForLeastWorkedMuscles() async throws -> [Exercise] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await dataStore.getRecommendedExercisesBasedOnPastSessions(userID: userID)
  }

  public func getCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await dataStore.getCompletedSinceLastWeek(userId: userID)
  }

  public func getCompletedToday() async throws -> [ExerciseSession] {
    guard let userID = self.currentUserID else {
      throw MusculosError.notFound
    }
    return await dataStore.getCompletedToday(userId: userID)
  }

  public func addSession(_ exercise: Exercise, dateAdded: Date, duration: Double, weight: Double) async throws {
    guard
      let currentUserID = self.currentUserID,
      let currentProfile = await userDataStore.loadProfile(userId: currentUserID)
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

    try await dataStore.addSession(exerciseSession)

    backgroundWorker.queueOperation(priority: .low) { [weak self] in
      try await self?.service.add(exerciseSession)
    }
  }

  private func shouldUseLocalStorage() -> Bool {
    guard let lastUpdated = dataStore.getLastUpdated() else {
      return false
    }
    return Date().timeIntervalSince(lastUpdated) < updateThreshold
  }
}

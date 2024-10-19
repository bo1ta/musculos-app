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
  @Injected(\NetworkContainer.exerciseSessionService) private var service: ExerciseSessionServiceProtocol
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol

  private let backgroundQueue = AsyncQueue()

  public init() {}

  public func getExerciseSession() async throws -> [ExerciseSession] {
    guard let currentUserID = userSessionManager.currentUserID else {
      throw MusculosError.notFound
    }

    guard await !shouldFetchFromLocalStorage() else {
      return await exerciseSessionDataStore.getAll(for: currentUserID)
    }

    let exerciseSessions = try await service.getAll()
    backgroundQueue.addOperation { [exerciseSessionDataStore] in
      try await exerciseSessionDataStore.importToStorage(remoteObjects: exerciseSessions, localObjectType: ExerciseSessionEntity.self)
    }
    return exerciseSessions

  }

  private func shouldFetchFromLocalStorage() async -> Bool {
    return await exerciseSessionDataStore.getCount() > 0
  }
}

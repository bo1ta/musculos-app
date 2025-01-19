//
//  RouteExerciseSessionRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.01.2025.
//

import Foundation
import Factory
import Models
import Storage
import Utility

// MARK: - RouteExerciseSessionRepositoryProtocol

public protocol RouteExerciseSessionRepositoryProtocol {
  func addRouteSession(_ session: RouteExerciseSession) async throws
  func getRouteSessionByID(_ uuid: UUID) async -> RouteExerciseSession?
  func getAllRouteSessionsForCurrentUser() async -> [RouteExerciseSession]
}

// MARK: - RouteExerciseSessionRepository

public struct RouteExerciseSessionRepository: @unchecked Sendable, BaseRepository, RouteExerciseSessionRepositoryProtocol {
  @Injected(\StorageContainer.coreDataStore) var dataStore: CoreDataStore

  public func addRouteSession(_ session: RouteExerciseSession) async throws {
    try await dataStore.importModel(session, of: RouteExerciseSessionEntity.self)
  }

  public func getRouteSessionByID(_ uuid: UUID) async -> RouteExerciseSession? {
    await dataStore.routeExerciseSessionByID(uuid)
  }

  public func getAllRouteSessionsForCurrentUser() async -> [RouteExerciseSession] {
    guard let currentUserID else {
      Logger.warning(message: "No current user ID found. Failing silently...")
      return []
    }
    return await dataStore.routeExerciseSessionsForUserID(currentUserID)
  }
}

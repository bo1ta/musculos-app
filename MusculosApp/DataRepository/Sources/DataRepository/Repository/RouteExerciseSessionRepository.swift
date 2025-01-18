//
//  RouteExerciseSessionRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 18.01.2025.
//

import Foundation
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
  public func addRouteSession(_ session: RouteExerciseSession) async throws {
    try await coreDataStore.importModel(session, of: RouteExerciseSessionEntity.self)
  }

  public func getRouteSessionByID(_ uuid: UUID) async -> RouteExerciseSession? {
    await coreDataStore.routeExerciseSessionByID(uuid)
  }

  public func getAllRouteSessionsForCurrentUser() async -> [RouteExerciseSession] {
    guard let currentUserID else {
      Logger.warning(message: "No current user ID found. Failing silently...")
      return []
    }
    return await coreDataStore.routeExerciseSessionsForUserID(currentUserID)
  }
}

//
//  ExerciseSessionDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import Factory
import Foundation
import Models
import Principle
import Utility

// MARK: - ExerciseSessionDataStoreProtocol

public protocol ExerciseSessionDataStoreProtocol: Sendable {
  func exerciseSessionsForUser(_ userID: UUID) async -> [ExerciseSession]
  func exerciseSessionCompletedToday(for userID: UUID) async -> [ExerciseSession]
  func exerciseSessionsCompletedSinceLastWeek(for userID: UUID) async -> [ExerciseSession]
  func exerciseSessionByID(_ id: UUID) async -> ExerciseSession?
}

// MARK: - ExerciseSessionDataStore

public struct ExerciseSessionDataStore: ExerciseSessionDataStoreProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) public var storageManager: StorageManagerType

  public func exerciseSessionsForUser(_ userID: UUID) async -> [ExerciseSession] {
    let predicate: NSPredicate = \ExerciseSessionEntity.user.uniqueID == userID
    return await storageManager.getAllEntities(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionCompletedToday(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getCurrentDayRange() as? (Date, Date) else {
      return []
    }

    let predicate: NSPredicate = \ExerciseSessionEntity.user
      .uniqueID == userID && \.dateAdded >= startDay && \.dateAdded <= endDay
    return await storageManager.getAllEntities(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionsCompletedSinceLastWeek(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date) else {
      return []
    }

    let predicate: NSPredicate = \ExerciseSessionEntity.user
      .uniqueID == userID && \.dateAdded >= startDay && \.dateAdded <= endDay
    return await storageManager.getAllEntities(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionByID(_ id: UUID) async -> ExerciseSession? {
    let predicate: NSPredicate = \ExerciseSessionEntity.uniqueID == id
    return await storageManager.getFirstEntity(ExerciseSessionEntity.self, predicate: predicate)
  }
}

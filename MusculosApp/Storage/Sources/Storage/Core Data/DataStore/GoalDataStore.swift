//
//  GoalDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation
import Models
import Utility

public protocol GoalDataStoreProtocol: BaseDataStore, Sendable {
  func getAll() async -> [Goal]
  func getAllForUser(_ userID: UUID) async -> [Goal]
  func getByID(_ goalID: UUID) async -> Goal?
  func add(_ goal: Goal) async throws
  func addProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws
  func getLastUpdated() -> Date?
  func updateLastUpdated(_ date: Date)
}

public struct GoalDataStore: GoalDataStoreProtocol {
  public init() {}

  public func getAll() async -> [Goal] {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .allObjects(
          ofType: GoalEntity.self,
          matching: nil,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }

  public func getAllForUser(_ userID: UUID) async -> [Goal] {
    return await storageManager.performRead { storage in
      guard let userProfile = storage.firstObject(
        of: UserProfileEntity.self,
        matching: PredicateProvider.userProfileById(userID)
      ) else {
        return []
      }
      return userProfile.toReadOnly().goals ?? []
    }
  }

  public func getByID(_ goalID: UUID) async -> Goal? {
    return await storageManager.performRead { storage in
      return storage.firstObject(
        of: GoalEntity.self,
        matching: PredicateProvider.goalByID(goalID)
      )?.toReadOnly()
    }
  }

  public func add(_ goal: Goal) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard let currentUser = writerDerivedStorage.firstObject(
        of: UserProfileEntity.self,
        matching: PredicateProvider.userProfileById(goal.user.userId)
      ) else {
        throw StorageError.invalidUser
      }

      let entity = writerDerivedStorage.findOrInsert(of: GoalEntity.self, using: PredicateProvider.goalByID(goal.id))
      entity.populateEntityFrom(goal, using: writerDerivedStorage)
    }
  }

  public func addProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws {
    try await storageManager.performWrite { storage in
      guard let goal = storage.firstObject(
        of: GoalEntity.self,
        matching: PredicateProvider.goalByID(goalID)
      ) else {
        throw MusculosError.notFound
      }

      guard !goal.progressHistory.contains(where: { $0.progressID == progressEntry.progressID }) else { return }
      let entity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
      entity.populateEntityFrom(progressEntry, using: storage)
    }
  }

  public func getLastUpdated() -> Date? {
    return UserDefaults.standard.object(forKey: UserDefaultsKey.goalsLastUpdated) as? Date
  }

  public func updateLastUpdated(_ date: Date = Date()) {
    UserDefaults.standard.set(date, forKey: UserDefaultsKey.goalsLastUpdated)
  }
}

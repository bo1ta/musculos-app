//
//  GoalDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import Factory
import Foundation
import Models
import Principle
import Utility

// MARK: - GoalDataStoreProtocol

public protocol GoalDataStoreProtocol: Sendable {
  func addGoal(_ goal: Goal) async throws
  func getGoalsForUserID(_ userID: UUID) async -> [Goal]
  func updateGoalProgress(userID: UUID, exerciseSession: ExerciseSession) async throws
  func goalByID(_ goalID: UUID) async -> Goal?
  func insertProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws
  func goalsPublisherForUserID(_ userID: UUID) -> FetchedResultsPublisher<GoalEntity>
  func progressEntriesForGoalID(_ goalID: UUID) async -> [ProgressEntry]
}

// MARK: - GoalDataStore

public struct GoalDataStore: GoalDataStoreProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) public var storageManager: StorageManagerType

  public init() { }

  public func addGoal(_ goal: Goal) async throws {
    try await storageManager.importEntity(goal, of: GoalEntity.self)
  }

  public func getGoalsForUserID(_ userID: UUID) async -> [Goal] {
    await storageManager.getAllEntities(GoalEntity.self, predicate: \GoalEntity.userID == userID)
  }

  public func updateGoalProgress(userID: UUID, exerciseSession: ExerciseSession) async throws {
    try await storageManager.performWrite { storage in
      guard let currentUser = UserDataStore.userProfileEntity(byID: userID, on: storage), !currentUser.goals.isEmpty else {
        return
      }

      currentUser.goals
        .filter { goal in
          guard
            let category = goal.category,
            let mappedCategories = ExerciseConstants.goalToExerciseCategories[category]
          else {
            return false
          }
          return mappedCategories.contains(exerciseSession.exercise.category)
        }
        .forEach { goal in
          let progressEntry = storage.insertNewObject(ofType: ProgressEntryEntity.self)
          progressEntry.progressID = UUID()
          progressEntry.dateAdded = Date()
          progressEntry.goal = goal
          progressEntry.value = 1 as NSNumber
        }
    }
  }

  public func goalByID(_ goalID: UUID) async -> Goal? {
    let predicate: NSPredicate = \GoalEntity.uniqueID == goalID
    return await storageManager.getFirstEntity(GoalEntity.self, predicate: predicate)
  }

  public func insertProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws {
    try await storageManager.performWrite { storage in
      let predicate: NSPredicate = \GoalEntity.uniqueID == goalID
      guard let goal = storage.firstObject(of: GoalEntity.self, matching: predicate) else {
        throw MusculosError.unexpectedNil
      }

      guard !goal.progressHistory.contains(where: { $0.progressID == progressEntry.id }) else {
        return
      }

      let entity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
      entity.populateEntityFrom(progressEntry, using: storage)
    }
  }

  public func goalsPublisherForUserID(_ userID: UUID) -> FetchedResultsPublisher<GoalEntity> {
    let predicate: NSPredicate = \GoalEntity.userID == userID
    let sortDescriptor = NSSortDescriptor(keyPath: \GoalEntity.dateAdded, ascending: false)
    return storageManager.createFetchedResultsPublisher(matching: predicate, sortDescriptors: [sortDescriptor], fetchLimit: nil)
  }

  public func progressEntriesForGoalID(_ goalID: UUID) async -> [ProgressEntry] {
    await storageManager.getAllEntities(ProgressEntryEntity.self, predicate: nil)
      .compactMap { $0 }
      .filter { $0.goal.id == goalID }
  }
}

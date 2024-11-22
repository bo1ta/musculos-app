//
//  ExerciseSessionDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation
import CoreData
import Models
import Utility

public protocol ExerciseSessionDataStoreProtocol: Sendable, BaseDataStore {
  func getAll(for userId: UUID) async -> [ExerciseSession]
  func getCompletedToday(userId: UUID) async -> [ExerciseSession]
  func getRecommendedExercisesBasedOnPastSessions(userID: UUID) async -> [Exercise]
  func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession]
  func getCount() async -> Int
  func addSession(_ exerciseSession: ExerciseSession) async throws
}

public struct ExerciseSessionDataStore: ExerciseSessionDataStoreProtocol {
  public typealias Syncable = ExerciseSessionEntity

  public init() { }

  public func getAll(for userId: UUID) async -> [ExerciseSession] {
    return await storageManager.performRead { viewStorage in
      let predicate = NSPredicate(format: "user.userId == %@", userId.uuidString)
      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: predicate,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }

  public func getCount() async -> Int {
    return await storageManager.performRead { viewStorage in
      return viewStorage.countObjects(ofType: ExerciseEntity.self)
    }
  }

  public func getCompletedToday(userId: UUID) async -> [ExerciseSession] {
    return await storageManager.performRead { viewStorage in
      guard
        let (startOfDay, endOfDay) = DateHelper.getCurrentDayRange() as? (Date, Date)
      else { return [] }

      let userPredicate = NSPredicate(
        format: "user.userId == %@",
        userId.uuidString
      )
      let datePredicate = NSPredicate(
        format: "dateAdded >= %@ AND dateAdded <= %@",
        argumentArray: [startOfDay, endOfDay]
      )
      let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: compundPredicate,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }

  public func getRecommendedExercisesBasedOnPastSessions(userID: UUID) async -> [Exercise] {
    return await storageManager.performRead { storage in
      let exerciseSessions = storage.allObjects(
        ofType: ExerciseSessionEntity.self,
        matching: nil,
        sortedBy: nil
      ).map { $0.toReadOnly() }

      let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
      let muscleIds = muscles.map { $0.id }

      return storage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "NOT (muscleId IN %@)", muscleIds),
        sortedBy: nil
      )
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }

  public func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession] {
    return await storageManager.performRead { viewStorage in
      guard let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date) else {
        return []
      }

      let userPredicate = NSPredicate(
        format: "user.userId == %@",
        userId.uuidString
      )
      let datePredicate = NSPredicate(
        format: "dateAdded >= %@ AND dateAdded <= %@",
        argumentArray: [startDay, endDay]
      )
      let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: compoundPredicate, sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }

  public func addSession(_ exerciseSession: ExerciseSession) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      let entity = writerDerivedStorage.insertNewObject(ofType: ExerciseSessionEntity.self)
      entity.populateEntityFrom(exerciseSession, using: writerDerivedStorage)
    }
  }
}

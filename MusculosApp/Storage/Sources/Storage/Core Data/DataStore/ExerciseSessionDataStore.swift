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
  func addSession(_ exercise: Exercise, date: Date, duration: Double, userId: UUID) async throws
  func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession]
  func getCount() async -> Int
}

public struct ExerciseSessionDataStore: BaseDataStore, ExerciseSessionDataStoreProtocol {
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

  public func importFrom(_ exerciseSessions: [ExerciseSession]) async throws {
    return try await storageManager.performWrite { storage in
      let existingSessions = storage.fetchUniquePropertyValues(of: ExerciseSessionEntity.self, property: "sessionId")
      let newSessions = exerciseSessions.filter { !existingSessions.contains($0.sessionId) }

      newSessions.forEach { exerciseSession in
        let entity = storage.insertNewObject(ofType: ExerciseSessionEntity.self)
        entity.populateEntityFrom(exerciseSession, using: storage)
      }

      MusculosLogger.logInfo(
        message: "Imported \(newSessions.count) new exercise sessions.",
        category: .coreData
      )
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

  public func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession] {
    return await storageManager.performRead { viewStorage in
      guard
        let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date)
      else { return [] }

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

  public func addSession(_ exercise: Exercise, date: Date, duration: Double, userId: UUID) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard
        let exerciseEntity = writerDerivedStorage.firstObject(of: ExerciseEntity.self, matching: PredicateFactory.exerciseById(exercise.id)),
        let userProfile = UserProfileEntity.userFromID(userId, on: writerDerivedStorage)
      else {
        throw MusculosError.notFound
      }

      let entity = writerDerivedStorage.insertNewObject(ofType: ExerciseSessionEntity.self)
      entity.sessionId = UUID()
      entity.dateAdded = date
      entity.exercise = exerciseEntity
      entity.user = userProfile
      entity.duration = NSNumber(floatLiteral: duration)
    }
  }
}

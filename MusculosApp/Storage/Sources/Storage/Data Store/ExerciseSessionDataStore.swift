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

public protocol ExerciseSessionDataStoreProtocol: Sendable {
  func getAll(for userId: UUID) async -> [ExerciseSession]
  func getCompletedToday(userId: UUID) async -> [ExerciseSession]
  func addSession(_ exercise: Exercise, date: Date, userId: UUID) async throws
  func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession]
}

public struct ExerciseSessionDataStore: BaseDataStore, ExerciseSessionDataStoreProtocol {
  
  let userProfileDataStore = UserDataStore()
  
  public init() { }
  
  public func getAll(for userId: UUID) async -> [ExerciseSession] {
    return await storageManager.performRead { viewStorage in
      let predicate = NSPredicate(format: "%K == %@", #keyPath(ExerciseSessionEntity.user.userId), userId.uuidString)
      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: predicate,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  public func getCompletedToday(userId: UUID) async -> [ExerciseSession] {
    guard let profile = await userProfileDataStore.loadProfile(userId: userId) else { return [] }
    
    return await storageManager.performRead { viewStorage in
      guard
        let (startOfDay, endOfDay) = DateHelper.getCurrentDayRange() as? (Date, Date)
      else { return [] }
      
      let userPredicate = NSPredicate(
        format: "user.email == %@",
        profile.email
      )
      let datePredicate = NSPredicate(
        format: "date >= %@ AND date <= %@",
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
    guard let profile = await userProfileDataStore.loadProfile(userId: userId) else { return [] }

    return await storageManager.performRead { viewStorage in
      guard
        let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date)
      else { return [] }
      
      let userPredicate = NSPredicate(
        format: "user.email == %@",
        profile.email
      )
      let datePredicate = NSPredicate(
        format: "date >= %@ AND date <= %@",
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
  
  public func addSession(_ exercise: Exercise, date: Date, userId: UUID) async throws {
    guard let profile = await userProfileDataStore.loadProfile(userId: userId) else { return }

    try await storageManager.performWrite { writerDerivedStorage in
      guard
        let exerciseEntity = writerDerivedStorage.firstObject(
          of: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
        ),
        let profile = writerDerivedStorage.firstObject(of: UserProfileEntity.self, matching: UserProfileEntity.CommonPredicate.currentUser(userId).nsPredicate)
      else { throw MusculosError.notFound }
      
      let entity = writerDerivedStorage.insertNewObject(ofType: ExerciseSessionEntity.self)
      entity.sessionId = UUID()
      entity.date = date
      entity.exercise = exerciseEntity
      entity.user = profile
    }
  }
}

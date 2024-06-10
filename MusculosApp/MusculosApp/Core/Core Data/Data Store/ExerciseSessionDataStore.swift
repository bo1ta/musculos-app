//
//  ExerciseSessionDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//

import Foundation
import CoreData

protocol ExerciseSessionDataStoreProtocol {
  func getAll() async -> [ExerciseSession]
  func getCompletedToday() async -> [ExerciseSession]
  func addSession(_ exercise: Exercise, date: Date) async throws
}

struct ExerciseSessionDataStore: BaseDataStore, ExerciseSessionDataStoreProtocol {
  func getAll() async -> [ExerciseSession] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: nil,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  func getCompletedToday() async -> [ExerciseSession] {
    return await storageManager.performReadOperation { viewStorage in
      guard
        let currentPerson = UserEntity.currentUser(with: viewStorage)?.toReadOnly(),
        let (startOfDay, endOfDay) = DateHelper.getCurrentDayRange() as? (Date, Date)
      else { return [] }
      
      let userPredicate = NSPredicate(
        format: "user.email == %@",
        currentPerson.email
      )
      let todayPredicate = NSPredicate(
        format: "date >= %@ AND date <= %@",
        argumentArray: [startOfDay, endOfDay]
      )
      let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, todayPredicate])
      
      return viewStorage
        .allObjects(
          ofType: ExerciseSessionEntity.self,
          matching: compundPredicate,
          sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
  
  func addSession(_ exercise: Exercise, date: Date) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      guard
        let exerciseEntity = writerDerivedStorage.firstObject(
          of: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
        ),
        let userEntity = UserEntity.currentUser(with: writerDerivedStorage)
      else { throw MusculosError.notFound }
      
      
      let entity = writerDerivedStorage.insertNewObject(ofType: ExerciseSessionEntity.self)
      entity.sessionId = UUID()
      entity.date = date
      entity.exercise = exerciseEntity
      entity.user = userEntity
    }
  }
}

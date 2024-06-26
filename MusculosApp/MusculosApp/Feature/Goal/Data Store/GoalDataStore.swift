//
//  GoalDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation

protocol GoalDataStoreProtocol: Sendable {
  func add(_ goal: Goal) async throws
  func getAll() async -> [Goal]
  func incrementCurrentValue(_ goal: Goal) async throws
}

struct GoalDataStore: BaseDataStore, GoalDataStoreProtocol {
  func add(_ goal: Goal) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      let entity = writerDerivedStorage.insertNewObject(ofType: GoalEntity.self)
      entity.name = goal.name
      entity.category = goal.category.rawValue
      entity.dateAdded = goal.dateAdded
      entity.endDate = goal.endDate
      entity.targetValue = NSNumber(integerLiteral: goal.targetValue)
      entity.isCompleted = false
      entity.frequency = goal.frequency.rawValue
    }
    await storageManager.saveChanges()
  }
  
  func getAll() async -> [Goal] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(
          ofType: GoalEntity.self,
          matching: nil,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  func incrementCurrentValue(_ goal: Goal) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorageq in
      let predicate = NSPredicate(format: "%K == %@", #keyPath(GoalEntity.name), goal.name)
      guard
        let goalEntity = writerDerivedStorageq.firstObject(of: GoalEntity.self, matching: predicate),
        !goalEntity.isCompleted,
        let currentValue = goalEntity.currentValue?.intValue
      else { return }
      
      goalEntity.currentValue = NSNumber(integerLiteral: currentValue + 1)
      if goalEntity.currentValue == goalEntity.targetValue {
        goalEntity.isCompleted = true
      }
    }
  }
}

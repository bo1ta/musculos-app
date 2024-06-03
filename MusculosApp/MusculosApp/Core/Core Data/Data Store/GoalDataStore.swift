//
//  GoalDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation

protocol GoalDataStoreProtocol {
  func add(_ goal: Goal) async throws
}

struct GoalDataStore: BaseDataStore, GoalDataStoreProtocol {
  func add(_ goal: Goal) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      let entity = writerDerivedStorage.insertNewObject(ofType: GoalEntity.self)
      entity.name = goal.name
      entity.category = goal.category.rawValue
      entity.endDate = goal.endDate
      entity.targetValue = goal.targetValue
      entity.isCompleted = false
      entity.frequency = goal.frequency.rawValue
    }
    
    storageManager.saveChanges()
  }
  
//  func getAll() -> [Goal] {
//    return viewStorage.
//  }
}

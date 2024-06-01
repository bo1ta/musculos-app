//
//  GoalDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation

struct GoalDataStore: BaseDataStore {
  func add(_ goal: Goal) async {
    await writerDerivedStorage.performAndSave {
      let entity = writerDerivedStorage.insertNewObject(ofType: GoalEntity.self)
      entity.name = goal.name
      entity.category = goal.category.rawValue
      entity.endDate = goal.endDate
      entity.targetValue = goal.targetValue
    }
    
    await viewStorage.performAndSave { }
  }
}

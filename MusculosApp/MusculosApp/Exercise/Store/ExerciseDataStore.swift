//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation

class ExerciseDataStore {
  private let syncPrivateContext = CoreDataStack.shared.syncPrivateContext
  private let mainContext = CoreDataStack.shared.mainContext
  
  func fetchExercises(limit: Int = 5, offset: Int = 0) throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.fetchLimit = limit
    fetchRequest.fetchOffset = offset
    fetchRequest.returnsObjectsAsFaults = false
    return try mainContext.fetch(fetchRequest)
  }
  
  func saveLocalChanges() async {
    await CoreDataStack.saveContext(syncPrivateContext)
    await CoreDataStack.saveContext(mainContext)
  }
}

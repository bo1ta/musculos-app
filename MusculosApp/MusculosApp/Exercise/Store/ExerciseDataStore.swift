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
    return try mainContext.fetch(fetchRequest)
  }
  
  func saveLocalChanges() async {
    await CoreDataStack.saveContext(syncPrivateContext)
    await CoreDataStack.saveContext(mainContext)
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    exercise.isFavorite = isFavorite
    await saveLocalChanges()
  }
  
  func fetchFavoriteExercises() throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
    return try mainContext.fetch(fetchRequest)
  }
}

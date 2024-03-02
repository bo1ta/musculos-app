//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation

class ExerciseDataStore {
  private let syncPrivateContext = CoreDataStack.shared.syncPrivateContext
  
  func fetchExercises(limit: Int = 5, offset: Int = 0) throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.fetchLimit = limit
    fetchRequest.fetchOffset = offset
    return try syncPrivateContext.fetch(fetchRequest)
  }
  
  func saveLocalChanges() async {
    await syncPrivateContext.saveContext()
    await CoreDataStack.shared.saveMainContext()
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    exercise.isFavorite = isFavorite
    await saveLocalChanges()
  }
  
  func fetchFavoriteExercises() throws -> [Exercise] {
    let fetchRequest = Exercise.fetchRequest()
    fetchRequest.predicate = NSPredicate(format: "isFavorite == true")
    return try syncPrivateContext.fetch(fetchRequest)
  }
}

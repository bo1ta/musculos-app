//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

class ExerciseDataStore: BaseDataStore {
  func fetchExercises(limit: Int = 5, offset: Int = 0) -> [Exercise] {
    let results = self.viewStorage.allObjects(ofType: ExerciseEntity.self, fetchLimit: limit, matching: nil, sortedBy: nil)
    return results.map { $0.toReadOnly() }
  }
  
  func fetchFavoriteExercises() -> [Exercise] {
    let predicate = NSPredicate(format: "isFavorite == true")
    let results = viewStorage.allObjects(ofType: ExerciseEntity.self, matching: predicate, sortedBy: nil)
    return results.map { $0.toReadOnly() }
  }
  
  func fetchExercisesByMuscle(_ muscle: String) -> [Exercise] {
    let predicate = NSPredicate(format: "ANY primaryMuscles CONTAINS[c] %@ OR ANY secondaryMuscles CONTAINS[c] %@", muscle, muscle)
    let results = viewStorage.allObjects(ofType: ExerciseEntity.self, matching: predicate, sortedBy: nil)
    return results.map { $0.toReadOnly() }
  }
  
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    await writerDerivedStorage.performAndSave { [weak self] in
      guard let self, let uuid = exercise.id else { return }
      
      let exercise = self.writerDerivedStorage.findOrInsert(of: ExerciseEntity.self, using: uuid)
      exercise.isFavorite = isFavorite
    }
    await viewStorage.performAndSave { }
  }
  
  func isFavorite(exercise: Exercise) -> Bool {
    let exercise = self.viewStorage.findOrInsert(of: ExerciseEntity.self, using: exercise.id!)
    return exercise.isFavorite
  }
  
  func importExercises(_ exercises: [Exercise]) async -> [Exercise] {
    await writerDerivedStorage.performAndSave { [weak self] in
      guard let self else { return }
      
      _ = exercises.map { exercise in
        let exerciseEntity = self.writerDerivedStorage.findOrInsert(of: ExerciseEntity.self, using: exercise.id)
        exerciseEntity.id = exercise.id
        exerciseEntity.name = exercise.name
        exerciseEntity.equipment = exercise.equipment
        exerciseEntity.category = exercise.category
        exerciseEntity.force = exercise.force
        exerciseEntity.imageUrls = exercise.imageUrls
        exerciseEntity.instructions = exercise.instructions
        exerciseEntity.level = exercise.level
        exerciseEntity.primaryMuscles = exercise.primaryMuscles
        exerciseEntity.secondaryMuscles = exercise.secondaryMuscles
      }
    }
    await viewStorage.performAndSave {}
    
    return exercises
  }
}

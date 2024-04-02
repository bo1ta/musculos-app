//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

struct ExerciseDataStore: BaseDataStore {
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async {
    await writerDerivedStorage.performAndSave {
      guard
        let exerciseId = exercise.id,
        let predicate = ExerciseEntity.CommonPredicate.byId(exerciseId).nsPredicate,
        let exercise = self.writerDerivedStorage.firstObject(of: ExerciseEntity.self, matching: predicate)
      else { return }
      
      exercise.isFavorite = isFavorite
    }
    await viewStorage.performAndSave { }
  }
  
  func isFavorite(exercise: Exercise) -> Bool {
    guard
      let exerciseId = exercise.id,
      let predicate = ExerciseEntity.CommonPredicate.byId(exerciseId).nsPredicate,
      let exercise = self.viewStorage.firstObject(of: ExerciseEntity.self, matching: predicate)
    else {
      return false
    }
    
    return exercise.isFavorite
  }
  
  func importExercises(_ exercises: [Exercise]) async -> [Exercise] {
    await writerDerivedStorage.performAndSave {
      _ = exercises.map { exercise in
        guard
          let exerciseId = exercise.id,
          let predicate = ExerciseEntity.CommonPredicate.byId(exerciseId).nsPredicate
        else { return }
        
        let exerciseEntity = self.writerDerivedStorage.findOrInsert(of: ExerciseEntity.self, using: predicate)
        exerciseEntity.exerciseId = exercise.id
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

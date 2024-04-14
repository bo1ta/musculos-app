//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

struct ExerciseDataStore: BaseDataStore {
  @MainActor
  func isFavorite(exercise: Exercise) -> Bool {
    return self.viewStorage
      .firstObject(
        of: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
      )?.isFavorite
    ?? false
  }
  
  @MainActor
  func getAll() -> [Exercise] {
    return viewStorage
      .allObjects(ofType: ExerciseEntity.self, matching: nil, sortedBy: nil)
      .map { $0.toReadOnly() }
  }
  
  func markAsFavorite(_ exercise: Exercise, isFavorite: Bool) async {
    await writerDerivedStorage.performAndSave {
      if let exercise = self.writerDerivedStorage.firstObject(
        of: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
      ) {
        exercise.isFavorite = isFavorite
      }
    }
    await viewStorage.performAndSave { }
  }
  
  func importFrom(_ exercises: [Exercise]) async -> [Exercise] {
    await writerDerivedStorage.performAndSave {
      for exercise in exercises {
        let exerciseEntity = self.writerDerivedStorage.findOrInsert(
          of: ExerciseEntity.self,
          using: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
        )
    
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

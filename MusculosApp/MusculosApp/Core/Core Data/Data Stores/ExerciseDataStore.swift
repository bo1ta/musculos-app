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
        
        let (primaryMuscles, secondaryMuscles) = constructMusclesRelationships(from: exercise)
        exerciseEntity.primaryMuscles = primaryMuscles
        exerciseEntity.secondaryMuscles = secondaryMuscles
      }
    }
    await viewStorage.performAndSave {}
    
    return exercises
  }
  
  func getByName(_ name: String) -> [Exercise] {
    return viewStorage
      .allObjects(
        ofType: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byName(name).nsPredicate,
        sortedBy: nil
      )
      .map { $0.toReadOnly() }
  }
  
  func addExercise(_ exercise: Exercise) async {
    await writerDerivedStorage.performAndSave {
      let exerciseEntity = self.writerDerivedStorage.insertNewObject(ofType: ExerciseEntity.self)
      
      exerciseEntity.exerciseId = exercise.id
      exerciseEntity.name = exercise.name
      exerciseEntity.equipment = exercise.equipment
      exerciseEntity.category = exercise.category
      exerciseEntity.force = exercise.force
      exerciseEntity.imageUrls = exercise.imageUrls
      exerciseEntity.instructions = exercise.instructions
      exerciseEntity.level = exercise.level

      let (primaryMuscles, secondaryMuscles) = constructMusclesRelationships(from: exercise)
      exerciseEntity.primaryMuscles = primaryMuscles
      exerciseEntity.secondaryMuscles = secondaryMuscles
    }
    
    await viewStorage.performAndSave { }
  }
}

// MARK: - Helpers

extension ExerciseDataStore {
  private func constructMusclesRelationships(from exercise: Exercise) -> (Set<PrimaryMuscleEntity>, Set<SecondaryMuscleEntity>) {
    var primaryMuscles = Set<PrimaryMuscleEntity>()
    for primaryMuscle in exercise.primaryMuscles {
      guard let muscleType = ExerciseConstants.MuscleType(rawValue: primaryMuscle) else { continue }
      
      let predicate = NSPredicate(format: "%K == %d", #keyPath(PrimaryMuscleEntity.muscleId), muscleType.id)
      let primaryMuscleEntity = self.writerDerivedStorage.findOrInsert(of: PrimaryMuscleEntity.self, using: predicate)
      primaryMuscles.insert(primaryMuscleEntity)
    }
    
    var secondaryMuscles = Set<SecondaryMuscleEntity>()
    for secondaryMuscle in exercise.secondaryMuscles {
      guard let muscleType = ExerciseConstants.MuscleType(rawValue: secondaryMuscle) else { continue }
      
      let predicate = NSPredicate(format: "%K == %d", #keyPath(SecondaryMuscleEntity.muscleId), muscleType.id)
      let secondaryMuscleEntity = self.writerDerivedStorage.findOrInsert(of: SecondaryMuscleEntity.self, using: predicate)
      secondaryMuscles.insert(secondaryMuscleEntity)
    }
    
    return (primaryMuscles, secondaryMuscles)
  }
}

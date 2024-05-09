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
        
        let (primaryMuscles, secondaryMuscles) = self.constructMusclesRelationships(
          exerciseEntity: exerciseEntity,
          primaryMuscles: exercise.primaryMuscles,
          secondaryMuscles: exercise.secondaryMuscles
        )
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

      let (primaryMuscles, secondaryMuscles) = self.constructMusclesRelationships(
        exerciseEntity: exerciseEntity,
        primaryMuscles: exercise.primaryMuscles,
        secondaryMuscles: exercise.secondaryMuscles
      )
      exerciseEntity.primaryMuscles = primaryMuscles
      exerciseEntity.secondaryMuscles = secondaryMuscles
    }
    
    await viewStorage.performAndSave { }
  }
  
  func getByMuscles(_ muscles: [MuscleType]) -> [Exercise] {
    let muscleIds = muscles.compactMap { $0.id }
    
    let primaryMusclesEntities = viewStorage.allObjects(
      ofType: PrimaryMuscleEntity.self,
      matching: NSPredicate(format: "muscleId IN %@", muscleIds),
      sortedBy: nil)
    
    var exerciseEntities: [ExerciseEntity] = []
    for entity in primaryMusclesEntities {
      exerciseEntities += entity.exercises
    }
    
    return exerciseEntities
      .map { $0.toReadOnly() }
  }
}

// MARK: - Helpers

extension ExerciseDataStore {
  private func constructMusclesRelationships(
    exerciseEntity: ExerciseEntity,
    primaryMuscles: [String],
    secondaryMuscles: [String]
  ) -> (Set<PrimaryMuscleEntity>, Set<SecondaryMuscleEntity>) {
    var primaryMusclesEntity = Set<PrimaryMuscleEntity>()
    var secondaryMusclesEntity = Set<SecondaryMuscleEntity>()
    
    for muscle in primaryMuscles {
      guard let muscleType = MuscleType(rawValue: muscle) else { continue }
      
      let predicate = NSPredicate(
        format: "%K == %d",
        #keyPath(PrimaryMuscleEntity.muscleId),
        muscleType.id
      )
      let entity = self.writerDerivedStorage.findOrInsert(of: PrimaryMuscleEntity.self, using: predicate)
      entity.muscleId = NSNumber(integerLiteral: muscleType.id)
      entity.name = muscleType.rawValue
      entity.exercises.insert(exerciseEntity)
      
      primaryMusclesEntity.insert(entity)
    }
    
    for muscle in secondaryMuscles {
      guard let muscleType = MuscleType(rawValue: muscle) else { continue }
      
      let predicate = NSPredicate(
        format: "%K == %d",
        #keyPath(SecondaryMuscleEntity.muscleId),
        muscleType.id
      )
      let entity = self.writerDerivedStorage.findOrInsert(of: SecondaryMuscleEntity.self, using: predicate)
      entity.muscleId = NSNumber(integerLiteral: muscleType.id)
      entity.name = muscleType.rawValue
      entity.exercises.insert(exerciseEntity)
      
      secondaryMusclesEntity.insert(entity)
    }
    
    return (primaryMusclesEntity, secondaryMusclesEntity)
  }
}

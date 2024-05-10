//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

// MARK: - Read methods
/// Should run on main thread since they access `viewStorage`
///

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
  
  @MainActor
  func getByName(_ name: String) -> [Exercise] {
    return viewStorage
      .allObjects(
        ofType: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byName(name).nsPredicate,
        sortedBy: nil
      )
      .map { $0.toReadOnly() }
  }
  
  @MainActor
  func getByMuscles(_ muscles: [MuscleType]) -> [Exercise] {
    let muscleIds = muscles.map { $0.id }
    
    return viewStorage.allObjects(
      ofType: PrimaryMuscleEntity.self,
      matching: NSPredicate(format: "muscleId IN %@", muscleIds),
      sortedBy: nil)
    .flatMap { $0.exercises }
    .map { $0.toReadOnly() }
  }
}

// MARK: - Write methods
/// Write operations are handled by `writerDerivedStorage`
/// On finish, Both `writerDerivedStorage` and `viewStorage` are saved
///

extension ExerciseDataStore {
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
        
        let (primaryMuscles, secondaryMuscles) = self.syncMusclesToExerciseEntity(
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
  
  func add(_ exercise: Exercise) async {
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
      
      let (primaryMuscles, secondaryMuscles) = self.syncMusclesToExerciseEntity(
        exerciseEntity: exerciseEntity,
        primaryMuscles: exercise.primaryMuscles,
        secondaryMuscles: exercise.secondaryMuscles
      )
      exerciseEntity.primaryMuscles = primaryMuscles
      exerciseEntity.secondaryMuscles = secondaryMuscles
    }
    
    await viewStorage.performAndSave { }
  }
}

// MARK: - Helpers

extension ExerciseDataStore {
  
  /// Returns a tuple of `PrimaryMuscleEntity`and `SecondaryMuscleEntity` sets synced to an `ExerciseEntity`
  /// Params:
  ///   `exerciseEntity` - The object to be inserted in the the many-to-many relationship
  ///   `primaryMuscles` - Muscles as strings
  ///   `secondaryMuscles` - Muscles as strings
  ///
  private func syncMusclesToExerciseEntity(
    exerciseEntity: ExerciseEntity,
    primaryMuscles: [String],
    secondaryMuscles: [String]
  ) -> (Set<PrimaryMuscleEntity>, Set<SecondaryMuscleEntity>) {
    let primaryMusclesEntity = Set<PrimaryMuscleEntity>(primaryMuscles
      .compactMap { muscle in
        guard let muscleType = MuscleType(rawValue: muscle) else { return nil }
        
        let predicate = NSPredicate(
          format: "%K == %d",
          #keyPath(PrimaryMuscleEntity.muscleId),
          muscleType.id
        )
        
        let entity = self.writerDerivedStorage.findOrInsert(of: PrimaryMuscleEntity.self, using: predicate)
        entity.muscleId = NSNumber(integerLiteral: muscleType.id)
        entity.name = muscleType.rawValue
        entity.exercises.insert(exerciseEntity)
        
        return entity
      }
    )
    
    let secondaryMusclesEntity = Set<SecondaryMuscleEntity>(secondaryMuscles
      .compactMap { muscle in
        guard let muscleType = MuscleType(rawValue: muscle) else { return nil }
        
        let predicate = NSPredicate(
          format: "%K == %d",
          #keyPath(SecondaryMuscleEntity.muscleId),
          muscleType.id
        )
        
        let entity = self.writerDerivedStorage.findOrInsert(of: SecondaryMuscleEntity.self, using: predicate)
        entity.muscleId = NSNumber(integerLiteral: muscleType.id)
        entity.name = muscleType.rawValue
        entity.exercises.insert(exerciseEntity)
        
        return entity
      }
    )
    
    return (primaryMusclesEntity, secondaryMusclesEntity)
  }
}


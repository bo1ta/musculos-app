//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

protocol ExerciseDataStoreProtocol {
  // read methods
  func isFavorite(_ exercise: Exercise) async -> Bool
  func getAll() async -> [Exercise]
  func getByName(_ name: String) async -> [Exercise]
  func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise]
  
  // write methods
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise]
  func add(_ exercise: Exercise) async throws
}

// MARK: - Read methods
///

struct ExerciseDataStore: BaseDataStore, ExerciseDataStoreProtocol {
  func isFavorite(_ exercise: Exercise) async -> Bool {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .firstObject(
          of: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
        )?.isFavorite
      ?? false
    }
  }
  
  func getAll() async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(ofType: ExerciseEntity.self, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
  
  func getByName(_ name: String) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byName(name).nsPredicate,
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      let muscleIds = muscles.map { $0.id }
      
      return viewStorage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "muscleId IN %@", muscleIds),
        sortedBy: nil)
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }
}

// MARK: - Write methods
/// Write operations are handled by `writerDerivedStorage`
/// On finish, Both `writerDerivedStorage` and `viewStorage` are saved
///

extension ExerciseDataStore {
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      if let exercise = writerDerivedStorage.firstObject(
        of: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
      ) {
        exercise.isFavorite = isFavorite
      }
    }

    await storageManager.saveChanges()
  }
  
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise] {
    try await storageManager.performWriteOperation { writerStorage in
      for exercise in exercises {
        let exerciseEntity = writerStorage.findOrInsert(
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
          secondaryMuscles: exercise.secondaryMuscles,
          writerStorage: writerStorage
        )
        exerciseEntity.primaryMuscles = primaryMuscles
        exerciseEntity.secondaryMuscles = secondaryMuscles
      }
    }

    await storageManager.saveChanges()
    
    return exercises
  }
  
  func add(_ exercise: Exercise) async throws {
    try await storageManager.performWriteOperation { writerStorage in
      let exerciseEntity = writerStorage.insertNewObject(ofType: ExerciseEntity.self)
      
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
        secondaryMuscles: exercise.secondaryMuscles,
        writerStorage: writerStorage
      )
      exerciseEntity.primaryMuscles = primaryMuscles
      exerciseEntity.secondaryMuscles = secondaryMuscles
    }

    await storageManager.saveChanges()
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
    secondaryMuscles: [String],
    writerStorage: StorageType
  ) -> (Set<PrimaryMuscleEntity>, Set<SecondaryMuscleEntity>) {
    let primaryMusclesEntity = Set<PrimaryMuscleEntity>(primaryMuscles
      .compactMap { muscle in
        let muscleType = MuscleType(rawValue: muscle)
        
        let predicate = NSPredicate(
          format: "%K == %d",
          #keyPath(PrimaryMuscleEntity.muscleId),
          muscleType!.id
        )
        
        let entity = writerStorage.findOrInsert(of: PrimaryMuscleEntity.self, using: predicate)
        entity.muscleId = NSNumber(integerLiteral: muscleType!.id)
        entity.name = muscleType!.rawValue
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
        
        let entity = writerStorage.findOrInsert(of: SecondaryMuscleEntity.self, using: predicate)
        entity.muscleId = NSNumber(integerLiteral: muscleType.id)
        entity.name = muscleType.rawValue
        entity.exercises.insert(exerciseEntity)
        
        return entity
      }
    )
    
    return (primaryMusclesEntity, secondaryMusclesEntity)
  }
}


//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

protocol ExerciseDataStoreProtocol {
  
  // MARK: - Read methods
  
  /// Checks if the given exercise is favorite
  ///
  func isFavorite(_ exercise: Exercise) async -> Bool
  
  /// Get all exercises given a fetch limit
  ///
  func getAll(fetchLimit: Int) async -> [Exercise]
  
  /// Get all exercises where name contains a given query
  ///
  func getByName(_ query: String) async -> [Exercise]
  
  /// Get all exercises given a list of muscle types
  ///
  func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise]
  
  /// Get all favorite exercises
  ///
  func getAllFavorites() async -> [Exercise]
  
  /// Get all exercises given a list of goals
  /// It maps the goals to a exercises category type
  ///
  func getAllByGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise]
  
  /// Get all exercises excluding a list of muscle types
  ///
  func getAllExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise]
  
  // MARK: - Write methods
  
  // write methods
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise]
  func add(_ exercise: Exercise) async throws
}

// MARK: - Read methods implementation

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
  
  func getAll(fetchLimit: Int = 20) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(ofType: ExerciseEntity.self, fetchLimit: fetchLimit, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
  
  func getAllFavorites() async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage.allObjects(
        ofType: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.isFavorite.nsPredicate,
        sortedBy: nil)
      .map { $0.toReadOnly() }
    }
  }
  
  func getByName(_ query: String) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          matching: ExerciseEntity.CommonPredicate.byName(query).nsPredicate,
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
        sortedBy: nil
      )
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }
  
  func getAllByGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      let predicate = mapGoalsToCategoryPredicate(goals)
      return viewStorage.allObjects(
        ofType: ExerciseEntity.self,
        fetchLimit: fetchLimit,
        matching: predicate,
        sortedBy: nil
      )
      .map { $0.toReadOnly() }
    }
  }
  
  func getAllExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performReadOperation { viewStorage in
      let muscleIds = muscles.map { $0.id }
      
      return viewStorage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "NOT (muscleId IN %@)", muscleIds),
        sortedBy: nil
      )
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }
}

// MARK: - Write methods implementation

extension ExerciseDataStore {
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      guard let exercise = writerDerivedStorage.firstObject(
        of: ExerciseEntity.self,
        matching: ExerciseEntity.CommonPredicate.byId(exercise.id).nsPredicate
      ) else {
        throw MusculosError.notFound
      }
      exercise.isFavorite = isFavorite
    }
    
    await storageManager.saveChanges()
  }
  
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise] {
    try await storageManager.performWriteOperation { writerStorage in
      guard let existingExercises = writerStorage.fetchUniquePropertyValues(forEntity: ExerciseEntity.entityName, property: "exerciseId") else { return }
      
      for exercise in exercises {
        guard !existingExercises.contains(exercise.id) else { continue }
        
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
    }
    
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
  }
}

// MARK: - Helpers

extension ExerciseDataStore {
  
  /// Syncs muscles to an ExerciseEntity, ensuring relationships are properly maintained.
  /// - Parameters:
  ///   - exerciseEntity: The `ExerciseEntity` to update.
  ///   - primaryMuscles: A list of primary muscle IDs.
  ///   - secondaryMuscles: A list of secondary muscle IDs.
  ///   - writerStorage: The storage context for writing.
  /// - Returns: A tuple containing sets of primary and secondary muscle entities.
  private func syncMusclesToExerciseEntity(
    exerciseEntity: ExerciseEntity,
    primaryMuscles: [String],
    secondaryMuscles: [String],
    writerStorage: StorageType
  ) -> (Set<PrimaryMuscleEntity>, Set<SecondaryMuscleEntity>) {
    let primaryMusclesEntity = Set<PrimaryMuscleEntity>(
      primaryMuscles
        .compactMap { muscle in
          guard let muscleType = MuscleType(rawValue: muscle) else { return nil }
          
          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(PrimaryMuscleEntity.muscleId),
            muscleType.id
          )
          
          if let entity = writerStorage.firstObject(of: PrimaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = writerStorage.insertNewObject(ofType: PrimaryMuscleEntity.self)
            entity.muscleId = NSNumber(integerLiteral: muscleType.id)
            entity.name = muscleType.rawValue
            entity.exercises.insert(exerciseEntity)
            return entity
          }
        }
    )
    
    let secondaryMusclesEntity = Set<SecondaryMuscleEntity>(
      secondaryMuscles
        .compactMap { muscle in
          guard let muscleType = MuscleType(rawValue: muscle) else { return nil }
          
          let predicate = NSPredicate(
            format: "%K == %d",
            #keyPath(SecondaryMuscleEntity.muscleId),
            muscleType.id
          )
          
          if let entity = writerStorage.firstObject(of: SecondaryMuscleEntity.self, matching: predicate) {
            entity.exercises.insert(exerciseEntity)
            return entity
          } else {
            let entity = writerStorage.insertNewObject(ofType: SecondaryMuscleEntity.self)
            entity.muscleId = NSNumber(integerLiteral: muscleType.id)
            entity.name = muscleType.rawValue
            entity.exercises.insert(exerciseEntity)
            return entity
          }
        }
    )
    
    return (primaryMusclesEntity, secondaryMusclesEntity)
  }
  
  private func mapGoalsToCategoryPredicate(_ goals: [Goal]) -> NSPredicate? {
    var predicate: NSPredicate?
    
    for goal in goals {
      if let categories = Self.goalToExerciseCategories[goal.category] {
        let categoryPredicate = NSPredicate(format: "category IN %@", categories)
        predicate = predicate == nil ? categoryPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [predicate!, categoryPredicate])
      }
    }
    
    return predicate
  }
}

// MARK: - Static properties

extension ExerciseDataStore {
  static let goalToExerciseCategories: [Goal.Category: [String]] = [
    .growMuscle: [
      ExerciseConstants.CategoryType.strength.rawValue,
      ExerciseConstants.CategoryType.powerlifting.rawValue,
      ExerciseConstants.CategoryType.strongman.rawValue,
      ExerciseConstants.CategoryType.olympicWeightlifting.rawValue
    ],
    .loseWeight: [
      ExerciseConstants.CategoryType.cardio.rawValue,
      ExerciseConstants.CategoryType.stretching.rawValue
    ]
  ]
}

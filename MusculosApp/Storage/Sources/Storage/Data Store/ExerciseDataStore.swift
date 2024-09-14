//
//  ExerciseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.02.2024.
//

import Foundation
import CoreData

@preconcurrency import Models
import Utility

public protocol ExerciseDataStoreProtocol: Sendable {
  
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
  
  /// Update favorite state for an exercise
  ///
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws

  /// Adds exercise to the data store
  ///
  func add(_ exercise: Exercise) async throws
}

// MARK: - Read methods implementation

public struct ExerciseDataStore: BaseDataStore, ExerciseDataStoreProtocol {
  public init() { }
  
  public func isFavorite(_ exercise: Exercise) async -> Bool {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .firstObject(
          of: ExerciseEntity.self,
          matching: PredicateFactory.exerciseById(exercise.id)
        )?.isFavorite ?? false
    }
  }
  
  public func getAll(fetchLimit: Int = 20) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .allObjects(ofType: ExerciseEntity.self, fetchLimit: fetchLimit, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
  
  public func getAllFavorites() async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      return viewStorage.allObjects(
        ofType: ExerciseEntity.self,
        matching: PredicateFactory.favoriteExercise(),
        sortedBy: nil)
      .map { $0.toReadOnly() }
    }
  }
  
  public func getByName(_ query: String) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          matching: PredicateFactory.exerciseByName(query),
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  public func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }
      
      return viewStorage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: PredicateFactory.musclesByIds(muscleIds),
        sortedBy: nil
      )
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }
  
  public func getAllByGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      let predicate = Self.mapGoalsToCategoryPredicate(goals)
      return viewStorage.allObjects(
        ofType: ExerciseEntity.self,
        fetchLimit: fetchLimit,
        matching: predicate,
        sortedBy: nil
      )
      .map { $0.toReadOnly() }
    }
  }
  
  public func getAllExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
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

public extension ExerciseDataStore {
  public func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard let exercise = writerDerivedStorage.firstObject(
        of: ExerciseEntity.self,
        matching: PredicateFactory.exerciseById(exercise.id)
      ) else {
        throw MusculosError.notFound
      }
      exercise.isFavorite = isFavorite
    }
  }
  
  public func add(_ exercise: Exercise) async throws {
    try await storageManager.performWrite { writerStorage in
      let exerciseEntity = writerStorage.insertNewObject(ofType: ExerciseEntity.self)
      
      exerciseEntity.exerciseId = exercise.id
      exerciseEntity.name = exercise.name
      exerciseEntity.equipment = exercise.equipment
      exerciseEntity.category = exercise.category
      exerciseEntity.force = exercise.force
      exerciseEntity.imageUrls = exercise.imageUrls
      exerciseEntity.instructions = exercise.instructions
      exerciseEntity.level = exercise.level

      exerciseEntity.primaryMuscles = PrimaryMuscleEntity.createFor(exerciseEntity: exerciseEntity, from: exercise.primaryMuscles, using: writerStorage)
      exerciseEntity.secondaryMuscles = SecondaryMuscleEntity.createFor(exerciseEntity: exerciseEntity, from: exercise.secondaryMuscles, using: writerStorage)
    }
  }
}

// MARK: - Static properties

extension ExerciseDataStore {
  private static func mapGoalsToCategoryPredicate(_ goals: [Goal]) -> NSPredicate? {
    var predicate: NSPredicate?

    for goal in goals {
      if let categories = Self.goalToExerciseCategories[goal.category] {
        let categoryPredicate = NSPredicate(format: "category IN %@", categories)
        predicate = predicate == nil ? categoryPredicate : NSCompoundPredicate(orPredicateWithSubpredicates: [predicate!, categoryPredicate])
      }
    }

    return predicate
  }
  
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

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

public protocol ExerciseDataStoreProtocol: BaseDataStore, Sendable {

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

  /// Get by the unique ID
  ///
  func getByID(_ exerciseID: UUID) async -> Exercise?

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

  /// Returns the total count of `ExerciseEntity` objects
  ///
  func getCount() async -> Int

  // MARK: - Write methods
  
  /// Update favorite state for an exercise
  ///
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws

  /// Adds exercise to the data store
  ///
  func add(_ exercise: Exercise) async throws
}

// MARK: - Read methods implementation

public struct ExerciseDataStore: ExerciseDataStoreProtocol {
  public init() { }

  public func getByID(_ exerciseID: UUID) async -> Exercise? {
    return await storageManager.performRead { viewStorage in
      return viewStorage.firstObject(
        of: ExerciseEntity.self,
        matching: PredicateProvider.exerciseById(exerciseID)
      )?.toReadOnly()
    }
  }

  public func isFavorite(_ exercise: Exercise) async -> Bool {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .firstObject(
          of: ExerciseEntity.self,
          matching: PredicateProvider.exerciseById(exercise.id)
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
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          matching: PredicateProvider.favoriteExercise(),
          sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }
  
  public func getByName(_ query: String) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          matching: PredicateProvider.exerciseByName(query),
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  public func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }
      
      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: PredicateProvider.musclesByIds(muscleIds),
          sortedBy: nil
        )
        .flatMap { $0.exercises }
        .map { $0.toReadOnly() }
    }
  }
  
  public func getAllByGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .allObjects(
          ofType: ExerciseEntity.self,
          fetchLimit: fetchLimit,
          matching: PredicateProvider.exerciseByGoals(goals),
          sortedBy: nil
        )
        .map { $0.toReadOnly() }
    }
  }
  
  public func getAllExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }
      
      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: NSPredicate(format: "NOT (muscleId IN %@)", muscleIds),
          sortedBy: nil
        )
        .flatMap { $0.exercises }
        .map { $0.toReadOnly() }
    }
  }

  public func getCount() async -> Int {
    return await storageManager.performRead { viewStorage in
      return viewStorage.countObjects(ofType: ExerciseEntity.self)
    }
  }
}

// MARK: - Write methods implementation

public extension ExerciseDataStore {
  public func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard let exercise = writerDerivedStorage.firstObject(
        of: ExerciseEntity.self,
        matching: PredicateProvider.exerciseById(exercise.id)
      ) else {
        throw MusculosError.notFound
      }
      exercise.isFavorite = isFavorite
    }
  }
  
  public func add(_ exercise: Exercise) async throws {
    try await self.handleObjectSync(remoteObject: exercise, localObjectType: ExerciseEntity.self)
  }
}

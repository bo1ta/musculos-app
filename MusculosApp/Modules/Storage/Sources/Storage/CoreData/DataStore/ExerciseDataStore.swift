//
//  ExerciseDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import Factory
import Foundation
import Models
import Principle
import Utility

// MARK: - ExerciseDataStoreProtocol

public protocol ExerciseDataStoreProtocol: Sendable {
  var storageManager: StorageManagerType { get }

  func getExercises(fetchLimit: Int) async -> [Exercise]
  func getExercises() async -> [Exercise]
  func exerciseByID(_ exerciseID: UUID) async -> Exercise?
  func exerciseRecommendationsByHistory(for _: UUID) async -> [Exercise]
  func favoriteExercises() async -> [Exercise]
  func exercisesByQuery(_ nameQuery: String) async -> [Exercise]
  func exercisesForMuscles(_ muscles: [MuscleType]) async -> [Exercise]
  func exercisesForGoal(_ goal: Goal) async -> [Exercise]
  func exercisesForGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise]
  func exercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise]
  func exercisesForWorkoutGoal(_ workoutGoal: WorkoutGoal) async -> [Exercise]
  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws
  func exercisePublisherForID(_ exerciseID: UUID) -> EntityPublisher<ExerciseEntity>
  func addRating(_ exerciseRating: ExerciseRating) async throws
  func addExercise(_ exercise: Exercise) async throws
}

// MARK: - ExerciseDataStore

public struct ExerciseDataStore: ExerciseDataStoreProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) public var storageManager

  public init() { }

  public func getExercises() async -> [Exercise] {
    await storageManager.getAllEntities(ExerciseEntity.self, predicate: nil)
  }

  public func getExercises(fetchLimit: Int) async -> [Exercise] {
    await storageManager.getAllEntities(ExerciseEntity.self, fetchLimit: fetchLimit, predicate: nil)
  }

  public func exerciseByID(_ exerciseID: UUID) async -> Exercise? {
    let predicate: NSPredicate = \ExerciseEntity.uniqueID == exerciseID
    return await storageManager.getFirstEntity(ExerciseEntity.self, predicate: predicate)
  }

  public func exerciseRecommendationsByHistory(for _: UUID) async -> [Exercise] {
    await storageManager.performRead { storage in
      let exerciseSessions = storage
        .allObjects(ofType: ExerciseSessionEntity.self, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }

      let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
      let muscleIds = muscles.map { $0.id }

      return storage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "NOT (muscleID IN %@)", muscleIds),
        sortedBy: nil)
        .flatMap { $0.exercises }
        .map { $0.toReadOnly() }
    }
  }

  public func favoriteExercises() async -> [Exercise] {
    let predicate: NSPredicate = \ExerciseEntity.isFavorite == true
    return await storageManager.getAllEntities(ExerciseEntity.self, predicate: predicate)
  }

  public func exercisesByQuery(_ nameQuery: String) async -> [Exercise] {
    let predicate: NSPredicate = \ExerciseEntity.name | contains(nameQuery)
    return await storageManager.getAllEntities(ExerciseEntity.self, predicate: predicate)
  }

  public func exercisesForMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { storage in
      let muscleIDs = muscles.map { $0.id }
      let predicate = NSPredicate(
        format: "%K IN %@",
        #keyPath(PrimaryMuscleEntity.muscleID),
        muscleIDs)
      return storage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: predicate,
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForGoal(_ goal: Goal) async -> [Exercise] {
    guard
      let goalCategory = goal.category,
      let exerciseCategories = ExerciseConstants.goalToExerciseCategories[goalCategory]
    else {
      return []
    }

    let predicate = NSPredicate(
      format: "%K IN %@",
      #keyPath(ExerciseEntity.category),
      exerciseCategories)
    return await storageManager.getAllEntities(ExerciseEntity.self, predicate: predicate)
  }

  public func exercisesForGoals(_ goals: [Goal], fetchLimit: Int = 50) async -> [Exercise] {
    var predicate: NSPredicate?

    for goal in goals {
      if let categories = ExerciseConstants.goalToExerciseCategories[goal.category ?? ""] {
        let categoryPredicate = NSPredicate(
          format: "%K IN %@",
          #keyPath(ExerciseEntity.category),
          categories)

        predicate =
          if predicate == nil {
            categoryPredicate
          } else {
            NSCompoundPredicate(orPredicateWithSubpredicates: [
              predicate!, // swiftlint:disable:this force_unwrapping
              categoryPredicate,
            ])
          }
      }
    }

    return await storageManager.getAllEntities(ExerciseEntity.self, fetchLimit: fetchLimit, predicate: predicate)
  }

  public func exercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }
      let predicate = NSPredicate(format: "NOT (muscleID IN %@)", muscleIds)

      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: predicate,
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForWorkoutGoal(_ workoutGoal: WorkoutGoal) async -> [Exercise] {
    let categories = workoutGoal.goalCategory.mappedExerciseCategories.map { $0.rawValue }
    let predicate = NSPredicate(format: "%K IN %@", #keyPath(ExerciseEntity.category), categories)
    return await storageManager.getAllEntities(ExerciseEntity.self, predicate: predicate)
  }

  public func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { storage in
      guard
        let exercise = storage.firstObject(
          of: ExerciseEntity.self,
          matching: \ExerciseEntity.uniqueID == exercise.id)
      else {
        throw MusculosError.unexpectedNil
      }

      exercise.isFavorite = isFavorite
      storage.saveIfNeeded()
    }
  }

  public func exercisePublisherForID(_ exerciseID: UUID) -> EntityPublisher<ExerciseEntity> {
    storageManager.createEntityPublisher(matching: \ExerciseEntity.uniqueID == exerciseID)
  }

  public func addRating(_ exerciseRating: ExerciseRating) async throws {
    try await storageManager.importEntity(exerciseRating, of: ExerciseRatingEntity.self)
  }

  public func addExercise(_ exercise: Exercise) async throws {
    try await storageManager.importEntity(exercise, of: ExerciseEntity.self)
  }
}

//
//  ExerciseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Foundation
import Models
import Utility
import Storage
import NetworkClient
import Factory
import Queue

public actor ExerciseRepository: BaseRepository {
  @Injected(\StorageContainer.userManager) private var userSessionManager: UserSessionManagerProtocol
  @Injected(\NetworkContainer.exerciseService) private var service: ExerciseServiceProtocol
  @Injected(\StorageContainer.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol

  private let backgroundQueue = AsyncQueue()

  public init() {}

  public func getExercises() async throws -> [Exercise] {
    guard await !shouldFetchExercisesFromLocalStorage() else {
      return await exerciseDataStore.getAll(fetchLimit: 20)
    }

    let exercises = try await service.getExercises()
    backgroundQueue.addOperation(priority: .medium) { [exerciseDataStore] in
      try await exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    if let exercise = await exerciseDataStore.getByID(exerciseID) {
      return exercise
    } else {
      let exercise = try await service.getExerciseDetails(for: exerciseID)
      backgroundQueue.addOperation(priority: .medium) { [exerciseDataStore] in
        try await exerciseDataStore.add(exercise)
      }
      return exercise
    }
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    guard await !shouldFetchExercisesFromLocalStorage() else {
      return await exerciseDataStore.getAllFavorites()
    }

    let exercises = try await service.getFavoriteExercises()
    backgroundQueue.addOperation(priority: .medium) { [exerciseDataStore] in
      try await exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }


  public func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
    backgroundQueue.addOperation { [service] in
      try await service.setFavoriteExercise(exercise, isFavorite: isFavorite)
    }
  }

  public func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
    let exercises = try await service.getByWorkoutGoal(workoutGoal)
    backgroundQueue.addOperation(priority: .low) { [exerciseDataStore] in
      try await exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserID = userSessionManager.currentUserID else {
      throw MusculosError.notFound
    }

    let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUserID)
    guard !exerciseSessions.isEmpty else {
      throw MusculosError.notFound
    }

    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    return await exerciseDataStore.getAllExcludingMuscles(muscles)
  }

  public func getRecommendedExercisesByGoals() async throws -> [Exercise] {
    let goals = await goalDataStore.getAll()
    guard !goals.isEmpty else {
      throw MusculosError.notFound
    }

    return await exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
  }

  public func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
    let exercises = try await service.searchByMuscleQuery(query)
    backgroundQueue.addOperation(priority: .medium) { [exerciseDataStore] in
      try await exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }

  private func shouldFetchExercisesFromLocalStorage() async -> Bool {
    return await exerciseDataStore.getCount() >= 20
  }
}

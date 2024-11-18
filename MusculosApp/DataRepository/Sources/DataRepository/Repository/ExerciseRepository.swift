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

public actor ExerciseRepository: BaseRepository {
  @Injected(\NetworkContainer.exerciseService) private var service: ExerciseServiceProtocol
  @Injected(\StorageContainer.exerciseDataStore) private var exerciseDataStore: ExerciseDataStoreProtocol
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  @Injected(\StorageContainer.exerciseSessionDataStore) private var exerciseSessionDataStore: ExerciseSessionDataStoreProtocol
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  public init() {}

  public func addExercise(_ exercise: Exercise) async throws {
    try await exerciseDataStore.add(exercise)

    //    backgroundWorker.queueOperation(priority: .low) {
    //    }
  }

  public func getExercises() async throws -> [Exercise] {
    guard await !shouldFetchExercisesFromLocalStorage() else {
      return await exerciseDataStore.getAll(fetchLimit: 20)
    }

    let exercises = try await service.getExercises()

    backgroundWorker.queueOperation(priority: .low, operationType: .local) { [weak self] in
      try await self?.exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }

    return exercises
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    if let exercise = await exerciseDataStore.getByID(exerciseID) {
      return exercise
    } else {
      let exercise = try await service.getExerciseDetails(for: exerciseID)
      backgroundWorker.queueOperation(priority: .medium, operationType: .local) { [weak self] in
        try await self?.exerciseDataStore.add(exercise)
      }
      return exercise
    }
  }

  public func getExercisesCompletedSinceLastWeek() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getCompletedSinceLastWeek(userId: currentUserID).map(\.exercise)
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    guard await !shouldFetchExercisesFromLocalStorage() else {
      return await exerciseDataStore.getAllFavorites()
    }

    let exercises = try await service.getFavoriteExercises()
    backgroundWorker.queueOperation(priority: .low, operationType: .local) { [weak self] in
      try await self?.exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }


  public func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
    backgroundWorker.queueOperation(priority: .medium) { [weak self] in
      try await self?.service.setFavoriteExercise(exercise, isFavorite: isFavorite)
    }
  }

  public func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
    let exercises = try await service.getByWorkoutGoal(workoutGoal)
    backgroundWorker.queueOperation(priority: .low, operationType: .local) { [weak self] in
      try await self?.exerciseDataStore.importToStorage(remoteObjects: exercises, localObjectType: ExerciseEntity.self)
    }
    return exercises
  }

  public func getExercisesForMuscleTypes(_ muscleTypes: [MuscleType]) async -> [Exercise] {
    return await exerciseDataStore.getByMuscles(muscleTypes)
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserID = self.currentUserID else {
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
    guard let muscleType = MuscleType(rawValue: query) else {
      return try await service.searchByMuscleQuery(query)
    }

    let exercises = await exerciseDataStore.getByMuscle(muscleType)
    if exercises.count >= 10 {
      return exercises
    } else {
      let remoteExercises = try await service.searchByMuscleQuery(query)
      backgroundWorker.queueOperation(priority: .low, operationType: .local) { [weak self] in
        try await self?.exerciseDataStore.importToStorage(remoteObjects: remoteExercises, localObjectType: ExerciseEntity.self)
      }
      return remoteExercises
    }
  }

  private func shouldFetchExercisesFromLocalStorage() async -> Bool {
    return await exerciseDataStore.getCount() >= 20
  }
}

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
    guard self.isConnectedToInternet else {
      return await exerciseDataStore.getAll(fetchLimit: 20)
    }

    let exercises = try await service.getExercises()
    backgroundWorker.queueOperation { [weak self] in
      try await self?.exerciseDataStore.importExercises(exercises)
    }
    return exercises
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    let exercise = try await service.getExerciseDetails(for: exerciseID)
    backgroundWorker.queueOperation { [weak self] in
      try await self?.exerciseDataStore.add(exercise)
    }
    return exercise
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
    backgroundWorker.queueOperation { [weak self] in
      try await self?.exerciseDataStore.importExercises(exercises)
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
    backgroundWorker.queueOperation { [weak self] in
      try await self?.exerciseDataStore.importExercises(exercises)
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
      return []
    }

    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    let exercises = await exerciseDataStore.getAllExcludingMuscles(muscles)
    return exercises
  }

  public func getRecommendedExercisesByGoals() async throws -> [Exercise] {
    let goals = await goalDataStore.getAll()
    guard !goals.isEmpty else {
      return []
    }

    return await exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
  }

  public func searchByQuery(_ query: String) async throws -> [Exercise] {
    guard let muscleType = MuscleType(rawValue: query) else {
      return try await service.searchByQuery(query)
    }

    let exercises = await exerciseDataStore.getByMuscle(muscleType)
    if exercises.count >= 10 {
      return exercises
    } else {
      let remoteExercises = try await service.searchByQuery(query)
      backgroundWorker.queueOperation { [weak self] in
        try await self?.exerciseDataStore.importExercises(remoteExercises)
      }
      return remoteExercises
    }
  }

  public func getByMuscleGroup(_ muscleGroup: MuscleGroup) async throws -> [Exercise] {
    let localExercises = await exerciseDataStore.getByMuscleGroup(muscleGroup)
    guard localExercises.count < 50 else {
      return localExercises
    }

    let remoteExercises = try await service.getByMuscleGroup(muscleGroup)
    backgroundWorker.queueOperation { [weak self] in
      try await self?.exerciseDataStore.importExercises(remoteExercises)
    }
    return remoteExercises
  }

  private func shouldFetchExercisesFromLocalStorage() async -> Bool {
    return await exerciseDataStore.getCount() >= 20
  }
}

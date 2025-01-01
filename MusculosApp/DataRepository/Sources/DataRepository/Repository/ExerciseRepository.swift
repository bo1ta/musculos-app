//
//  ExerciseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

public protocol ExerciseRepositoryProtocol: Actor {
  func addExercise(_ exercise: Exercise) async throws
  func getExercises() async throws -> [Exercise]
  func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise
  func getExercisesCompletedSinceLastWeek() async throws -> [Exercise]
  func getFavoriteExercises() async throws -> [Exercise]
  func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise]
  func getExercisesForMuscleTypes(_ muscleTypes: [MuscleType]) async -> [Exercise]
  func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise]
  func getRecommendedExercisesByGoals() async -> [Exercise]
  func searchByQuery(_ query: String) async throws -> [Exercise]
  func getByMuscleGroup(_ muscleGroup: MuscleGroup) async throws -> [Exercise]
}

public actor ExerciseRepository: BaseRepository, ExerciseRepositoryProtocol {
  @Injected(\NetworkContainer.exerciseService) private var service: ExerciseServiceProtocol

  public init() { }

  public func addExercise(_ exercise: Exercise) async throws {
    try await coreDataStore.importModel(exercise, of: ExerciseEntity.self)

    backgroundWorker.queueOperation { [weak self] in
      try await self?.service.addExercise(exercise)
    }
  }

  public func getExercises() async throws -> [Exercise] {
    guard isConnectedToInternet else {
      return await coreDataStore.getAll(ExerciseEntity.self, fetchLimit: 20)
    }

    let exercises = try await service.getExercises()
    syncStorage(exercises, of: ExerciseEntity.self)
    return exercises
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    if let localExercise = await coreDataStore.exerciseByID(exerciseID), shouldUseLocalExercise(localExercise) {
      return localExercise
    }

    let exercise = try await service.getExerciseDetails(for: exerciseID)
    syncStorage(exercise, of: ExerciseEntity.self)
    return exercise
  }

  public func getExercisesCompletedSinceLastWeek() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return await coreDataStore.exerciseSessionsCompletedSinceLastWeek(for: currentUserID).map { $0.exercise }
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    guard !shouldUseLocalStorageForEntity(ExerciseEntity.self) else {
      return await coreDataStore.favoriteExercises(for: currentUserID)
    }

    let exercises = try await service.getFavoriteExercises()
    syncStorage(exercises, of: ExerciseEntity.self)
    return exercises
  }

  public func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await coreDataStore.favoriteExercise(exercise, isFavorite: isFavorite)

    backgroundWorker.queueOperation(priority: .medium) { [weak self] in
      try await self?.service.setFavoriteExercise(exercise, isFavorite: isFavorite)
    }
  }

  public func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
    guard !shouldUseLocalStorageForEntity(ExerciseEntity.self) else {
      return await coreDataStore.exercisesForWorkoutGoal(workoutGoal)
    }

    let exercises = try await service.getByWorkoutGoal(workoutGoal)
    syncStorage(exercises, of: ExerciseEntity.self)
    return exercises
  }

  public func getExercisesForMuscleTypes(_ muscleTypes: [MuscleType]) async -> [Exercise] {
    await coreDataStore.exercisesForMuscles(muscleTypes)
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    let exerciseSessions = await coreDataStore.exerciseSessionsForUser(currentUserID)
    guard !exerciseSessions.isEmpty else {
      return []
    }

    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    return await coreDataStore.exercisesExcludingMuscles(muscles)
  }

  public func getRecommendedExercisesByGoals() async -> [Exercise] {
    let goals = await coreDataStore.getAll(GoalEntity.self)
    guard !goals.isEmpty else {
      return []
    }

    return await coreDataStore.exercisesForGoals(goals, fetchLimit: 20)
  }

  public func searchByQuery(_ query: String) async throws -> [Exercise] {
    let exercises = await coreDataStore.exercisesByQuery(query)

    if !exercises.isEmpty {
      return exercises
    } else {
      let remoteExercises = try await service.searchByQuery(query)
      syncStorage(remoteExercises, of: ExerciseEntity.self)
      return remoteExercises
    }
  }

  public func getByMuscleGroup(_ muscleGroup: MuscleGroup) async throws -> [Exercise] {
    let localExercises = await coreDataStore.exercisesForMuscles(muscleGroup.muscles)
    guard localExercises.isEmpty else {
      return localExercises
    }

    let remoteExercises = try await service.getByMuscleGroup(muscleGroup)
    syncStorage(remoteExercises, of: ExerciseEntity.self)
    return remoteExercises
  }

  private func shouldUseLocalExercise(_ exercise: Exercise) -> Bool {
    if let updatedAt = exercise.updatedAt, Date().timeIntervalSince(updatedAt) < localStorageUpdateThreshold {
      return true
    }
    return false
  }
}

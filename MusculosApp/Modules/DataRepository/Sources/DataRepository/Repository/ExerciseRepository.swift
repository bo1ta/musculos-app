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

// MARK: - ExerciseRepositoryProtocol

public protocol ExerciseRepositoryProtocol: Sendable {
  func addExercise(_ exercise: Exercise) async throws
  func getExercises() async throws -> [Exercise]
  func getExercisesStream() async -> AsyncStream<Result<[Exercise], Error>>
  func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise
  func getExercisesCompletedSinceLastWeek() async throws -> [Exercise]
  func getFavoriteExercises() async throws -> [Exercise]
  func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise]
  func getExercisesForMuscleTypes(_ muscleTypes: [MuscleType]) async -> [Exercise]
  func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise]
  func getRecommendedExercisesByGoals() async -> [Exercise]
  func getExercisesForGoal(_ goal: Goal) async -> [Exercise]
  func searchByQuery(_ query: String) async throws -> [Exercise]
  func getByMuscleGroup(_ muscleGroup: MuscleGroup) async throws -> [Exercise]
  func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws
  func entityPublisherForID(_ exerciseID: UUID) -> EntityPublisher<ExerciseEntity>
}

// MARK: - ExerciseRepository

public struct ExerciseRepository: @unchecked Sendable, BaseRepository, ExerciseRepositoryProtocol {
  @Injected(\NetworkContainer.exerciseService) private var service: ExerciseServiceProtocol
  @Injected(\StorageContainer.coreDataStore) var dataStore: CoreDataStore
  @Injected(\.backgroundWorker) var backgroundWorker: BackgroundWorker

  public init() { }

  public func addExercise(_ exercise: Exercise) async throws {
    try await update(
      localTask: { try await dataStore.importModel(exercise, of: ExerciseEntity.self) },
      remoteTask: { try await service.addExercise(exercise) })
  }

  public func getExercises() async throws -> [Exercise] {
    try await fetch(
      forType: ExerciseEntity.self,
      localTask: { await dataStore.getAll(ExerciseEntity.self, fetchLimit: 40) },
      remoteTask: { try await service.getExercises() })
  }

  public func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
    guard
      let exercise = try await fetch(
        forType: ExerciseEntity.self,
        localTask: { await dataStore.exerciseByID(exerciseID) },
        remoteTask: { try await service.getExerciseDetails(for: exerciseID) })
    else {
      throw MusculosError.unexpectedNil
    }
    return exercise
  }

  public func getExercisesCompletedSinceLastWeek() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return await dataStore.exerciseSessionsCompletedSinceLastWeek(for: currentUserID).map { $0.exercise }
  }

  public func getExercisesStream() async -> AsyncStream<Result<[Exercise], Error>> {
    makeAsyncStream(
      localFetch: { await dataStore.getAll(ExerciseEntity.self) },
      remoteFetch: { try await service.getExercises() })
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return try await fetch(
      forType: ExerciseEntity.self,
      localTask: { await dataStore.favoriteExercises(for: currentUserID) },
      remoteTask: { try await service.getFavoriteExercises() })
  }

  public func setFavoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await update(
      localTask: { try await dataStore.favoriteExercise(exercise, isFavorite: isFavorite) },
      remoteTask: { try await service.setFavoriteExercise(exercise, isFavorite: isFavorite) })
  }

  public func getExercisesByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
    try await fetch(
      forType: ExerciseEntity.self,
      localTask: { await dataStore.exercisesForWorkoutGoal(workoutGoal) },
      remoteTask: { try await service.getByWorkoutGoal(workoutGoal) })
  }

  public func getExercisesForMuscleTypes(_ muscleTypes: [MuscleType]) async -> [Exercise] {
    await dataStore.exercisesForMuscles(muscleTypes)
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    let exerciseSessions = await dataStore.exerciseSessionsForUser(currentUserID)
    guard !exerciseSessions.isEmpty else {
      return []
    }

    let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
    return await dataStore.exercisesExcludingMuscles(muscles)
  }

  public func getRecommendedExercisesByGoals() async -> [Exercise] {
    let goals = await dataStore.getAll(GoalEntity.self)
    guard !goals.isEmpty else {
      return []
    }

    return await dataStore.exercisesForGoals(goals, fetchLimit: 20)
  }

  public func getExercisesForGoal(_ goal: Goal) async -> [Exercise] {
    await dataStore.exercisesForGoal(goal)
  }

  public func searchByQuery(_ query: String) async throws -> [Exercise] {
    try await fetch(
      forType: ExerciseEntity.self,
      localTask: { await dataStore.exercisesByQuery(query) },
      remoteTask: { try await service.searchByQuery(query) })
  }

  public func getByMuscleGroup(_ muscleGroup: MuscleGroup) async throws -> [Exercise] {
    try await fetch(
      forType: ExerciseEntity.self,
      localTask: { await dataStore.exercisesForMuscles(muscleGroup.muscles) },
      remoteTask: { try await service.getByMuscleGroup(muscleGroup) })
  }

  public func entityPublisherForID(_ exerciseID: UUID) -> EntityPublisher<ExerciseEntity> {
    dataStore.exercisePublisherForID(exerciseID)
  }
}

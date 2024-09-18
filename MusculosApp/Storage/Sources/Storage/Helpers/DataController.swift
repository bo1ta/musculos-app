//
//  DataController.swift
//
//
//  Created by Solomon Alexandru on 29.08.2024.
//

import SwiftUI
import Models
import Factory
import Combine
import Storage
import CoreData
import Utility

public final class DataController: @unchecked Sendable {

  // MARK: - Dependencies

  @Injected(\StorageContainer.userDataStore) private var userDataStore
  @Injected(\StorageContainer.userManager) private var userManager

  @LazyInjected(\StorageContainer.exerciseDataStore) private var exerciseDataStore
  @LazyInjected(\StorageContainer.goalDataStore) private var goalDataStore
  @LazyInjected(\StorageContainer.exerciseSessionDataStore) private var exerciseSessionDataStore
  @LazyInjected(\StorageContainer.workoutDataStore) private var workoutDataStore

  private var currentUserSession: UserSession? {
    return userManager.currentUserSession
  }

  private var currentUserID: UUID? {
    return currentUserSession?.user.id
  }

  public var modelEventPublisher: AnyPublisher<CoreModelNotificationHandler.Event, Never> {
    return coreModelNotificationHandler.eventPublisher
  }

  private let coreModelNotificationHandler: CoreModelNotificationHandler

  public init() {
    self.coreModelNotificationHandler = CoreModelNotificationHandler(
      managedObjectContext: StorageContainer.shared.storageManager().writerDerivedStorage as? NSManagedObjectContext
    )
  }
}

// MARK: - Exercise data

extension DataController {
  public func getExercises(fetchLimit: Int = 20) async -> [Exercise] {
    return await exerciseDataStore.getAll(fetchLimit: fetchLimit)
  }

  public func isExerciseFavorite(_ exercise: Exercise) async -> Bool {
    return await exerciseDataStore.isFavorite(exercise)
  }

  public func getFavoriteExercises() async throws -> [Exercise] {
    return await exerciseDataStore.getAllFavorites()
  }

  public func getExercisesByName(_ name: String) async -> [Exercise] {
    return await exerciseDataStore.getByName(name)
  }

  public func getExercisesByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await exerciseDataStore.getByMuscles(muscles)
  }

  public func getExercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await exerciseDataStore.getAllExcludingMuscles(muscles)
  }

  public func updateIsFavoriteForExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    return try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
  }

  public func addExercise(_ exercise: Exercise) async throws {
    return try await exerciseDataStore.add(exercise)
  }

  public func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserID else {
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
    guard currentUserSession != nil else {
      throw MusculosError.notFound
    }

    let goals = await goalDataStore.getAll()
    guard !goals.isEmpty else {
      throw MusculosError.notFound
    }

    return await exerciseDataStore.getAllByGoals(goals, fetchLimit: 20)
  }
}

// MARK: - ExerciseSession Data

extension DataController {
  public func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserID  else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getAll(for: currentUserID)
  }

  public func getExercisesCompletedToday() async throws -> [ExerciseSession] {
    guard let currentUserID else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getCompletedToday(userId: currentUserID)
  }

  public func getExercisesCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let currentUserID else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getCompletedSinceLastWeek(userId: currentUserID)
  }

  public func addExerciseSession(for exercise: Exercise, date: Date) async throws {
    guard let currentUserID else {
      throw MusculosError.notFound
    }
    return try await exerciseSessionDataStore.addSession(exercise, date: date, userId: currentUserID)
  }
}

// MARK: - Goal Data

extension DataController {
  public func getGoals() async -> [Goal] {
    return await goalDataStore.getAll()
  }

  public func addGoal(_ goal: Goal) async throws {
    return try await goalDataStore.add(goal)
  }

  public func incrementGoalScore(_ goal: Goal) async throws {
    return try await goalDataStore.incrementCurrentValue(goal)
  }
}

// MARK: - UserProfile Data

extension DataController {
  public func addUserProfile(_ profile: UserProfile) async throws {
    return try await userDataStore.createUser(profile: profile)
  }

  public func updateUserProfile(
    weight: Int? = nil,
    height: Int? = nil,
    primaryGoalId: Int? = nil,
    level: String? = nil,
    isOnboarded: Bool = false
  ) async throws {
    guard let currentUserID else {
      throw MusculosError.notFound
    }
    return try await userDataStore.updateProfile(
      userId: currentUserID,
      weight: weight,
      height: height,
      primaryGoalId: primaryGoalId,
      level: level,
      isOnboarded: isOnboarded
    )
  }

  public func getCurrentUserProfile() async -> UserProfile? {
    guard let currentUserID else {
      return nil
    }
    return await userDataStore.loadProfile(userId: currentUserID)
  }
}

// MARK: - Workout data

extension DataController {
  public func addWorkout(_ workout: Workout) async throws {
    guard let currentUserID else { throw MusculosError.notFound }

    try await workoutDataStore.create(workout, userId: currentUserID)
  }
}

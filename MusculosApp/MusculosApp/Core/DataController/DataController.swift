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
  @Injected(\.exerciseDataStore) private var exerciseDataStore
  @Injected(\.goalDataStore) private var goalDataStore
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore
  @Injected(\.userDataStore) private var userDataStore
  @Injected(\.modelCacheManager) private var modelCacheManager
  @Injected(\.userManager) private var userManager

  private var currentUserSession: UserSession? {
    return userManager.currentSession()
  }

  var modelEventPublisher: AnyPublisher<CoreModelNotificationHandler.Event, Never> {
    return coreModelNotificationHandler.eventPublisher
  }

  private let coreModelNotificationHandler: CoreModelNotificationHandler

  init() {
    self.coreModelNotificationHandler = CoreModelNotificationHandler(
      managedObjectContext: StorageManager.shared.writerDerivedStorage as? NSManagedObjectContext
    )
  }
}

// MARK: - Exercise data

extension DataController {
  func getExercises() async throws -> [Exercise] {
    if let cachedExercises = try modelCacheManager.getCachedExercises() {
      return cachedExercises
    } else {
      let exercises = await exerciseDataStore.getAll(fetchLimit: 20)
      modelCacheManager.cacheExercises(exercises)
      return exercises
    }
  }

  func isExerciseFavorite(_ exercise: Exercise) async -> Bool {
    return await exerciseDataStore.isFavorite(exercise)
  }

  func getFavoriteExercises() async throws -> [Exercise] {
    return await exerciseDataStore.getAllFavorites()
  }

  func getExercisesByName(_ name: String) async -> [Exercise] {
    return await exerciseDataStore.getByName(name)
  }

  func getExercisesByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await exerciseDataStore.getByMuscles(muscles)
  }

  func getExercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await exerciseDataStore.getAllExcludingMuscles(muscles)
  }

  func updateIsFavoriteForExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    return try await exerciseDataStore.setIsFavorite(exercise, isFavorite: isFavorite)
  }

  @discardableResult
  func importExercises(_ exercises: [Exercise]) async throws -> [Exercise] {
    return try await exerciseDataStore.importFrom(exercises)
  }

  func addExercise(_ exercise: Exercise) async throws {
    return try await exerciseDataStore.add(exercise)
  }

  func getRecommendedExercisesByMuscleGroups() async throws -> [Exercise] {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }

    let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUserSession.userId)
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
  func getExerciseSessions() async throws -> [ExerciseSession] {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }

    if let cachedExerciseSessions = try modelCacheManager.getCachedExerciseSessions() {
      return cachedExerciseSessions
    } else {
      let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUserSession.userId)
      modelCacheManager.cacheExerciseSessions(exerciseSessions)
      return exerciseSessions
    }
  }

  func getExercisesCompletedToday() async throws -> [ExerciseSession] {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getCompletedToday(userId: currentUserSession.userId)
  }

  func getExercisesCompletedSinceLastWeek() async throws -> [ExerciseSession] {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }
    return await exerciseSessionDataStore.getCompletedSinceLastWeek(userId: currentUserSession.userId)
  }

  func addExerciseSession(for exercise: Exercise, date: Date) async throws {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }
    return try await exerciseSessionDataStore.addSession(exercise, date: date, userId: currentUserSession.userId)
  }
}

// MARK: - Goal Data

extension DataController {
  func getGoals() async throws -> [Goal] {
    if let cachedGoals = try modelCacheManager.getCachedGoals() {
      return cachedGoals
    } else {
      let goals = await goalDataStore.getAll()
      modelCacheManager.cacheGoals(goals)
      return goals
    }
  }

  func addGoal(_ goal: Goal) async throws {
    return try await goalDataStore.add(goal)
  }

  func incrementGoalScore(_ goal: Goal) async throws {
    return try await goalDataStore.incrementCurrentValue(goal)
  }
}

// MARK: - UserProfile Data

extension DataController {
  func addUserProfile(_ profile: UserProfile) async throws {
    return try await userDataStore.createUser(profile: profile)
  }

  func updateUserProfile(
    weight: Int? = nil,
    height: Int? = nil,
    primaryGoalId: Int? = nil,
    level: String? = nil,
    isOnboarded: Bool = false
  ) async throws {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }
    return try await userDataStore.updateProfile(
      userId: currentUserSession.userId,
      weight: weight,
      height: height,
      primaryGoalId: primaryGoalId,
      level: level,
      isOnboarded: isOnboarded
    )
  }
}

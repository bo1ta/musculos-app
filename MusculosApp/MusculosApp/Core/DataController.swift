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
import Cache
import Utility

public final class DataController: @unchecked Sendable {
  @Injected(\.exerciseDataStore) private var exerciseDataStore
  @Injected(\.goalDataStore) private var goalDataStore
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore
  @Injected(\.userDataStore) private var userDataStore

  @Injected(\.userManager) private var userManager

  private let cacheExpiry: Expiry = Expiry.date(DateHelper.nowPlusMinutes(5))
  private let cacheLimit: UInt = 40
  private let defaultCacheKey = "default"

  private var goalCache: MemoryStorage<String, [Goal]>
  private var exerciseCache: MemoryStorage<String, [Exercise]>
  private var exerciseSessionCache: MemoryStorage<String, [ExerciseSession]>
  private var userCache: MemoryStorage<String, UserProfile?>

  private var currentUserSession: UserSession? {
    return userManager.currentSession()
  }

  init() {
    let memoryConfig = MemoryConfig(
      expiry: cacheExpiry,
      countLimit: cacheLimit,
      totalCostLimit: cacheLimit
    )
    self.goalCache = MemoryStorage(config: memoryConfig)
    self.exerciseCache = MemoryStorage(config: memoryConfig)
    self.exerciseSessionCache = MemoryStorage(config: memoryConfig)
    self.userCache = MemoryStorage(config: memoryConfig)

    NotificationCenter.default.addObserver(self, selector: #selector(invalidateCache), name: .NSManagedObjectContextDidSave, object: StorageManager.shared.viewStorage as? NSManagedObjectContext)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  @objc
  private func invalidateCache() {
    userCache.removeAll()
    exerciseCache.removeAll()
    goalCache.removeAll()
    exerciseSessionCache.removeAll()
  }
}

// MARK: - Exercise data

extension DataController {
  func getExercises() async throws -> [Exercise] {
    let isCacheExpired = try exerciseCache.isExpiredObject(forKey: defaultCacheKey)
    if isCacheExpired {
      let exercises = await exerciseDataStore.getAll(fetchLimit: 20)
      exerciseCache.setObject(exercises, forKey: defaultCacheKey)
      return exercises
    } else {
      return try exerciseCache.object(forKey: defaultCacheKey)
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

    let isCacheExpired = try exerciseSessionCache.isExpiredObject(forKey: defaultCacheKey)
    if isCacheExpired {
      let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUserSession.userId)
      exerciseSessionCache.setObject(exerciseSessions, forKey: defaultCacheKey)
      return exerciseSessions
    } else {
      return try exerciseSessionCache.object(forKey: defaultCacheKey)
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
    let isCacheExpired = try goalCache.isExpiredObject(forKey: defaultCacheKey)
    if isCacheExpired {
      let goals = await goalDataStore.getAll()
      goalCache.setObject(goals, forKey: defaultCacheKey)
      return goals
    } else {
      return try goalCache.object(forKey: defaultCacheKey)
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

  func getCurrentUserProfile() async throws -> UserProfile? {
    guard let currentUserSession else {
      throw MusculosError.notFound
    }

    let isCacheExpired = try userCache.isExpiredObject(forKey: defaultCacheKey)
    if isCacheExpired {
      let userProfile = await userDataStore.loadProfile(userId: currentUserSession.userId)
      userCache.setObject(userProfile, forKey: defaultCacheKey)
      return userProfile
    } else {
      return try userCache.object(forKey: defaultCacheKey)
    }
  }
}

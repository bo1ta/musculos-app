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

public class DataController {
  @Injected(\.exerciseDataStore) private var exerciseDataStore
  @Injected(\.goalDataStore) private var goalDataStore
  @Injected(\.exerciseSessionDataStore) private var exerciseSessionDataStore
  @Injected(\.userManager) private var userManager

  private let cacheExpiry: Expiry = Expiry.date(DateHelper.nowPlusMinutes(5))
  private let cacheLimit: UInt = 40
  private let defaultCacheKey = "default"

  private var goalCache: MemoryStorage<String, [Goal]>
  private var exerciseCache: MemoryStorage<String, [Exercise]>
  private var exerciseSessionCache: MemoryStorage<String, [ExerciseSession]>

  init() {
    let memoryConfig = MemoryConfig(
      expiry: cacheExpiry,
      countLimit: cacheLimit,
      totalCostLimit: cacheLimit
    )
    self.goalCache = MemoryStorage(config: memoryConfig)
    self.exerciseCache = MemoryStorage(config: memoryConfig)
    self.exerciseSessionCache = MemoryStorage(config: memoryConfig)

    NotificationCenter.default.addObserver(self, selector: #selector(invalidateCache), name: .NSManagedObjectContextDidSave, object: StorageManager.shared.viewStorage as? NSManagedObjectContext)
  }

  deinit {
    NotificationCenter.default.removeObserver(self)
  }

  func getExercises() async throws -> [Exercise] {
    let isCacheExpired = try exerciseCache.isExpiredObject(forKey: defaultCacheKey)

    if isCacheExpired {
      let exercises = await fetchExercises()
      exerciseCache.setObject(exercises, forKey: defaultCacheKey)
      return exercises
    } else {
      return try exerciseCache.object(forKey: defaultCacheKey)
    }
  }

  func getGoals() async throws -> [Goal] {
    let isCacheExpired = try goalCache.isExpiredObject(forKey: defaultCacheKey)

    if isCacheExpired {
      let goals = await fetchGoals()
      goalCache.setObject(goals, forKey: defaultCacheKey)
      return goals
    } else {
      return try goalCache.object(forKey: defaultCacheKey)
    }
  }

  func getExerciseSessions() async throws -> [ExerciseSession] {
    let isCacheExpired = try exerciseSessionCache.isExpiredObject(forKey: defaultCacheKey)

    if isCacheExpired {
      let exerciseSessions = await fetchExerciseSessions()
      exerciseSessionCache.setObject(exerciseSessions, forKey: defaultCacheKey)
      return exerciseSessions
    } else {
      return try exerciseSessionCache.object(forKey: defaultCacheKey)
    }
  }

  func getExercisesCompletedToday() async throws -> [ExerciseSession] {
    guard let userID = userManager.currentSession()?.userId else { throw MusculosError.notFound }
    return await exerciseSessionDataStore.getCompletedToday(userId: userID)
  }

  func getFavoriteExercises() async -> [Exercise] {
    return await exerciseDataStore.getAllFavorites()
  }

  private func fetchExercises() async -> [Exercise] {
    return await exerciseDataStore.getAll(fetchLimit: 20)
  }

  private func fetchGoals() async -> [Goal] {
    return await goalDataStore.getAll()
  }

  private func fetchExerciseSessions() async -> [ExerciseSession] {
    guard let userID = userManager.currentSession()?.userId else { return [] }
    return await exerciseSessionDataStore.getCompletedSinceLastWeek(userId: userID)
  }

  @objc
  private func invalidateCache() {
    exerciseCache.removeAll()
    goalCache.removeAll()
    exerciseSessionCache.removeAll()
  }
}

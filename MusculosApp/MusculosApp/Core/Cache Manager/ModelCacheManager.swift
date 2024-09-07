//
//  ModelCacheManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 06.09.2024.
//

import Cache
import Models
import Utility

public final class ModelCacheManager: @unchecked Sendable {
  private let defaultCacheKey = "default"
  private let cacheExpiry = Expiry.date(DateHelper.nowPlusMinutes(5))
  private let cacheLimit: UInt = 40

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
  }

  // MARK: - Goal Cache

  func cacheGoals(_ goals: [Goal]) {
    goalCache.setObject(goals, forKey: defaultCacheKey)
  }

  func getCachedGoals() throws -> [Goal]? {
    let isExpired = try goalCache.isExpiredObject(forKey: defaultCacheKey)
    return isExpired ? nil : try goalCache.object(forKey: defaultCacheKey)
  }

  func invalidateGoalCache() {
    goalCache.removeAll()
  }

  // MARK: - Exercise Cache

  func cacheExercises(_ exercises: [Exercise]) {
    exerciseCache.setObject(exercises, forKey: defaultCacheKey)
  }

  func getCachedExercises() throws -> [Exercise]? {
    let isExpired = try exerciseCache.isExpiredObject(forKey: defaultCacheKey)
    return isExpired ? nil : try exerciseCache.object(forKey: defaultCacheKey)
  }

  func invalidateExerciseCache() {
    exerciseCache.removeAll()
  }

  // MARK: - Exercise Session Cache

  func cacheExerciseSessions(_ exerciseSessions: [ExerciseSession]) {
    exerciseSessionCache.setObject(exerciseSessions, forKey: defaultCacheKey)
  }

  func getCachedExerciseSessions() throws -> [ExerciseSession]? {
    let isExpired = try exerciseSessionCache.isExpiredObject(forKey: defaultCacheKey)
    return isExpired ? nil : try exerciseSessionCache.object(forKey: defaultCacheKey)
  }

  func invalidateExerciseSessionCache() {
    exerciseSessionCache.removeAll()
  }
}

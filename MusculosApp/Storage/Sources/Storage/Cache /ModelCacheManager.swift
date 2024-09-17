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
  nonisolated(unsafe) private static let cacheExpiry = Expiry.date(DateHelper.nowPlusMinutes(5))

  private static let defaultCacheKey = "default"
  private static let cacheLimit: UInt = 40

  private let memoryConfig = MemoryConfig(
    expiry: cacheExpiry,
    countLimit: cacheLimit,
    totalCostLimit: cacheLimit
  )

  private lazy var userProfileCache: MemoryStorage<String, UserProfile> = {
    let memoryConfig = MemoryConfig(expiry: Expiry.seconds(10), countLimit: 1, totalCostLimit: 1)
    return MemoryStorage(config: memoryConfig)
  }()

  private lazy var goalCache: MemoryStorage<String, [Goal]> = {
    return MemoryStorage(config: memoryConfig)
  }()

  private lazy var exerciseCache: MemoryStorage<String, [Exercise]> = {
    return MemoryStorage(config: memoryConfig)
  }()

  private lazy var exerciseSessionCache: MemoryStorage<String, [ExerciseSession]> = {
    return MemoryStorage(config: memoryConfig)
  }()

  public init() { }

  // MARK: - Goal Cache

  public func cacheGoals(_ goals: [Goal]) {
    goalCache.setObject(goals, forKey: Self.defaultCacheKey)
  }

  public func getCachedGoals() throws -> [Goal]? {
    let isExpired = try goalCache.isExpiredObject(forKey: Self.defaultCacheKey)
    return isExpired ? nil : try goalCache.object(forKey: Self.defaultCacheKey)
  }

  public func invalidateGoalCache() {
    goalCache.removeAll()
  }

  // MARK: - Exercise Cache

  public func cacheExercises(_ exercises: [Exercise]) {
    exerciseCache.setObject(exercises, forKey: Self.defaultCacheKey)
  }

  public func getCachedExercises() throws -> [Exercise]? {
    let isExpired = try exerciseCache.isExpiredObject(forKey: Self.defaultCacheKey)
    return isExpired ? nil : try exerciseCache.object(forKey: Self.defaultCacheKey)
  }

  public func invalidateExerciseCache() {
    exerciseCache.removeAll()
  }

  // MARK: - Exercise Session Cache

  public func cacheExerciseSessions(_ exerciseSessions: [ExerciseSession]) {
    exerciseSessionCache.setObject(exerciseSessions, forKey: Self.defaultCacheKey)
  }

  public func getCachedExerciseSessions() throws -> [ExerciseSession]? {
    let isExpired = try exerciseSessionCache.isExpiredObject(forKey: Self.defaultCacheKey)
    return isExpired ? nil : try exerciseSessionCache.object(forKey: Self.defaultCacheKey)
  }

  public func invalidateExerciseSessionCache() {
    exerciseSessionCache.removeAll()
  }
}

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
  @Injected(\StorageContainer.exerciseDataStore) private var exerciseDataStore
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore
  @Injected(\StorageContainer.exerciseSessionDataStore) private var exerciseSessionDataStore
  @Injected(\StorageContainer.workoutDataStore) private var workoutDataStore
  @Injected(\StorageContainer.userDataStore) private var userDataStore
  @Injected(\StorageContainer.modelCacheManager) private var modelCacheManager
  @Injected(\StorageContainer.userManager) private var userManager

  private var currentUserSession: UserSession? {
    switch userManager.currentState() {
    case .authenticated(let userSession):
      return userSession
    default:
      return nil
    }
  }

  private var currentUserID: UUID? {
    return currentUserSession?.user.id
  }

  public var modelEventPublisher: AnyPublisher<CoreModelNotificationHandler.Event, Never> {
    return coreModelNotificationHandler.eventPublisher
  }

  private let coreModelNotificationHandler: CoreModelNotificationHandler

  private var cancellables = Set<AnyCancellable>()

  public init() {
    self.coreModelNotificationHandler = CoreModelNotificationHandler(
      managedObjectContext: StorageContainer.shared.storageManager().writerDerivedStorage as? NSManagedObjectContext
    )
    self.coreModelNotificationHandler.eventPublisher
      .receive(on: DispatchQueue.main)
      .sink { [weak self] event in
        switch event {
        case .didUpdateExercise:
          self?.modelCacheManager.invalidateExerciseCache()
        case .didUpdateExerciseSession:
          self?.modelCacheManager.invalidateExerciseSessionCache()
        case .didUpdateGoal:
          self?.modelCacheManager.invalidateGoalCache()
        }
      }
      .store(in: &cancellables)
  }
}

// MARK: - Exercise data

extension DataController {
  public func getExercises() async throws -> [Exercise] {
    if let cachedExercises = try modelCacheManager.getCachedExercises() {
      return cachedExercises
    } else {
      let exercises = await exerciseDataStore.getAll(fetchLimit: 20)
      modelCacheManager.cacheExercises(exercises)
      return exercises
    }
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

    if let cachedExerciseSessions = try modelCacheManager.getCachedExerciseSessions() {
      return cachedExerciseSessions
    } else {
      let exerciseSessions = await exerciseSessionDataStore.getAll(for: currentUserID)
      modelCacheManager.cacheExerciseSessions(exerciseSessions)
      return exerciseSessions
    }
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
  public func getGoals() async throws -> [Goal] {
    if let cachedGoals = try modelCacheManager.getCachedGoals() {
      return cachedGoals
    } else {
      let goals = await goalDataStore.getAll()
      modelCacheManager.cacheGoals(goals)
      return goals
    }
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

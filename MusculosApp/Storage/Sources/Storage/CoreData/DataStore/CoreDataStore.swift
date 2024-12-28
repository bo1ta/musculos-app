//
//  CoreDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import Factory
import Foundation
import Models
import Utility

public typealias EntityType = Object & ReadOnlyConvertible

public final class CoreDataStore: @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) private var storageManager: StorageManagerType

  public init() {}

  public func getAll<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> [T.ReadOnlyType] {
    return await storageManager.performRead { storage in
      storage.allObjects(ofType: type, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getAll<T: EntityType>(_ type: T.Type, fetchLimit: Int, predicate: NSPredicate? = nil) async -> [T.ReadOnlyType] {
    return await storageManager.performRead { storage in
      storage.allObjects(ofType: type, fetchLimit: fetchLimit, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getCount<T: Object>(_ type: T.Type, predicate: NSPredicate? = nil) async -> Int {
    return await storageManager.performRead { storage in
      storage.countObjects(ofType: type, matching: predicate)
    }
  }

  public func firstObject<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> T.ReadOnlyType? {
    return await storageManager.performRead { storage in
      storage.firstObject(of: type, matching: predicate)?.toReadOnly()
    }
  }

  public func update<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await storageManager.performWrite { storage in
      guard let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) else {
        return
      }
      firstObject.updateEntityFrom(model, using: storage)
    }
  }

  public func delete<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await storageManager.performWrite { storage in
      guard let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) else {
        return
      }
      storage.deleteObject(firstObject)
    }
  }

  public func importModel<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) async throws {
    try await storageManager.performWrite { storage in
      if let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) {
        firstObject.updateEntityFrom(model, using: storage)
      } else {
        let newObject = storage.insertNewObject(ofType: type)
        newObject.populateEntityFrom(model, using: storage)
      }
    }
  }

  public func importModels<T: EntitySyncable>(_ models: [T.ModelType], of type: T.Type) async throws {
    try await storageManager.performWrite { storage in
      for model in models {
        if let firstObject = storage.firstObject(of: type, matching: model.matchingPredicate()) {
          firstObject.updateEntityFrom(model, using: storage)
        } else {
          let newObject = storage.insertNewObject(ofType: type)
          newObject.populateEntityFrom(model, using: storage)
        }
      }
    }
  }
}

// MARK: - UserProfile

public extension CoreDataStore {
  func userProfile(for userID: UUID) async -> UserProfile? {
    return await firstObject(UserProfileEntity.self, predicate: PredicateProvider.userProfileById(userID))
  }

  func userProfile(by email: String) async -> UserProfile? {
    return await firstObject(UserProfileEntity.self, predicate: PredicateProvider.userProfileByEmail(email))
  }

  func updateProfile(userId: UUID, weight: Int?, height: Int?, primaryGoalID: UUID?, level: String?, isOnboarded: Bool = false) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard let userProfile = writerDerivedStorage.firstObject(
        of: UserProfileEntity.self,
        matching: PredicateProvider.userProfileById(userId)
      ) else {
        throw MusculosError.notFound
      }

      userProfile.level = level
      userProfile.isOnboarded = isOnboarded

      if let weight {
        userProfile.weight = weight as NSNumber
      }

      if let height {
        userProfile.height = height as NSNumber
      }

      if let primaryGoalID {
        userProfile.primaryGoalID = primaryGoalID
      }
    }
  }

  func userExperience(for userID: UUID) async -> UserExperience? {
    return await storageManager.performRead { storage in
      guard
        let userProfile = storage.firstObject(of: UserProfileEntity.self, matching: PredicateProvider.userProfileById(userID)),
        let experience = userProfile.userExperience
      else {
        return nil
      }

      return experience.toReadOnly()
    }
  }
}

// MARK: - Goal

public extension CoreDataStore {
  func updateGoalProgress(userID: UUID, exerciseSession: ExerciseSession) async throws {
    try await storageManager.performWrite { storage in
      guard let currentUser = UserProfileEntity.userFromID(userID, on: storage), !currentUser.goals.isEmpty else {
        return
      }

      for goal in currentUser.goals {
        guard let category = goal.category else {
          continue
        }

        if let mappedCategories = ExerciseConstants.goalToExerciseCategories[category], mappedCategories.contains(exerciseSession.exercise.category) {
          let progressEntry = storage.insertNewObject(ofType: ProgressEntryEntity.self)
          progressEntry.progressID = UUID()
          progressEntry.dateAdded = Date()
          progressEntry.goal = goal
          progressEntry.value = 1 as NSNumber
        }
      }
    }
  }

  func goal(by goalID: UUID) async -> Goal? {
    return await firstObject(GoalEntity.self, predicate: PredicateProvider.goalByID(goalID))
  }

  func insertProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws {
    try await storageManager.performWrite { storage in
      guard let goal = storage.firstObject(of: GoalEntity.self, matching: PredicateProvider.goalByID(goalID)) else {
        throw MusculosError.notFound
      }

      guard !goal.progressHistory.contains(where: { $0.progressID == progressEntry.progressID }) else {
        return
      }

      let entity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
      entity.populateEntityFrom(progressEntry, using: storage)
    }
  }
}

// MARK: - Exercise Session

public extension CoreDataStore {
  func exerciseSessionsForUser(_ userID: UUID) async -> [ExerciseSession] {
    return await getAll(ExerciseSessionEntity.self, predicate: PredicateProvider.exerciseSessionsForUser(userID))
  }

  func exerciseSessionCompletedToday(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getCurrentDayRange() as? (Date, Date) else {
      return []
    }

    let userPredicate = PredicateProvider.exerciseSessionsForUser(userID)
    let datePredicate = PredicateProvider.exerciseSessionsBetweenDates(startDay, endDate: endDay)
    let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

    return await getAll(ExerciseSessionEntity.self, predicate: compundPredicate)
  }

  func exerciseSessionsCompletedSinceLastWeek(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date) else {
      return []
    }

    let userPredicate = PredicateProvider.exerciseSessionsForUser(userID)
    let datePredicate = PredicateProvider.exerciseSessionsBetweenDates(startDay, endDate: endDay)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

    return await getAll(ExerciseSessionEntity.self, predicate: compoundPredicate)
  }
}

// MARK: - Exercise

public extension CoreDataStore {
  func exerciseByID(_ exerciseID: UUID) async -> Exercise? {
    return await firstObject(ExerciseEntity.self, predicate: PredicateProvider.exerciseById(exerciseID))
  }

  func exerciseRecommendationsByHistory(for _: UUID) async -> [Exercise] {
    return await storageManager.performRead { storage in
      let exerciseSessions = storage
        .allObjects(ofType: ExerciseSessionEntity.self, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }

      let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
      let muscleIds = muscles.map { $0.id }

      return storage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "NOT (muscleId IN %@)", muscleIds),
        sortedBy: nil
      )
      .flatMap { $0.exercises }
      .map { $0.toReadOnly() }
    }
  }

  func favoriteExercises(for _: UUID) async -> [Exercise] {
    return await getAll(ExerciseEntity.self, predicate: PredicateProvider.favoriteExercise())
  }

  func exercisesByQuery(_ nameQuery: String) async -> [Exercise] {
    return await getAll(ExerciseEntity.self, predicate: PredicateProvider.exerciseByName(nameQuery))
  }

  func exercisesForMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { storage in
      let muscleIds = muscles.map { $0.id }

      return storage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: PredicateProvider.musclesByIds(muscleIds),
          sortedBy: nil
        )
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  func exercisesForGoals(_ goals: [Goal], fetchLimit: Int = 50) async -> [Exercise] {
    return await getAll(ExerciseEntity.self, fetchLimit: fetchLimit, predicate: PredicateProvider.exerciseByGoals(goals))
  }

  func exercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }

      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: NSPredicate(format: "NOT (muscleID IN %@)", muscleIds),
          sortedBy: nil
        )
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  func exercisesForWorkoutGoal(_ workoutGoal: WorkoutGoal) async -> [Exercise] {
    let mappedCategories = workoutGoal.goalCategory.mappedExerciseCategories.map { $0.rawValue }
    return await getAll(ExerciseEntity.self, predicate: PredicateProvider.exerciseByCategories(mappedCategories))
  }

  func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { storage in
      guard let exercise = storage.firstObject(of: ExerciseEntity.self, matching: PredicateProvider.exerciseById(exercise.id)) else {
        throw MusculosError.notFound
      }

      exercise.isFavorite = isFavorite
      storage.saveIfNeeded()
    }
  }
}

// MARK: - Workout

public extension CoreDataStore {
  func workout(by id: UUID) async -> Workout? {
    return await firstObject(WorkoutEntity.self, predicate: PredicateProvider.workoutByID(id))
  }

  func insertWorkout(_ workout: Workout) async throws {
    return try await importModel(workout, of: WorkoutEntity.self)
  }
}

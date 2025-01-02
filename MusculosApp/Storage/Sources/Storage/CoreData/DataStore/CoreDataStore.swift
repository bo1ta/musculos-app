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

// MARK: - CoreDataStore

public final class CoreDataStore: @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) private var storageManager: StorageManagerType

  public init() { }

  public func getAll<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> [T.ReadOnlyType] {
    await storageManager.performRead { storage in
      storage.allObjects(ofType: type, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getAll<T: EntityType>(_ type: T.Type, fetchLimit: Int, predicate: NSPredicate? = nil) async -> [T.ReadOnlyType] {
    await storageManager.performRead { storage in
      storage.allObjects(ofType: type, fetchLimit: fetchLimit, matching: predicate, sortedBy: nil)
        .map { $0.toReadOnly() }
    }
  }

  public func getCount(_ type: (some Object).Type, predicate: NSPredicate? = nil) async -> Int {
    await storageManager.performRead { storage in
      storage.countObjects(ofType: type, matching: predicate)
    }
  }

  public func getFirstObject<T: EntityType>(_ type: T.Type, predicate: NSPredicate? = nil) async -> T.ReadOnlyType? {
    await storageManager.performRead { storage in
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

extension CoreDataStore {
  public func userProfileByID(_ userID: UUID) async -> UserProfile? {
    await getFirstObject(UserProfileEntity.self, predicate: PredicateProvider.userProfileById(userID))
  }

  public func userProfileByEmail(_ email: String) async -> UserProfile? {
    await getFirstObject(UserProfileEntity.self, predicate: PredicateProvider.userProfileByEmail(email))
  }

  public func updateProfile(
    userId: UUID,
    weight: Int?,
    height: Int?,
    primaryGoalID: UUID?,
    level: String?,
    isOnboarded: Bool = false)
    async throws
  {
    try await storageManager.performWrite { writerDerivedStorage in
      guard
        let userProfile = writerDerivedStorage.firstObject(
          of: UserProfileEntity.self,
          matching: PredicateProvider.userProfileById(userId))
      else {
        throw MusculosError.unexpectedNil
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

  public func userExperienceForUserID(_ userID: UUID) async -> UserExperience? {
    await storageManager.performRead { storage in
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

// MARK: - User Experience

extension CoreDataStore {
  public func userExperienceEntryByID(_ id: UUID) async -> UserExperienceEntry? {
    await getFirstObject(UserExperienceEntryEntity.self, predicate: PredicateProvider.userExperienceEntryByID(id))
  }
}

// MARK: - Goal

extension CoreDataStore {
  public func updateGoalProgress(userID: UUID, exerciseSession: ExerciseSession) async throws {
    try await storageManager.performWrite { storage in
      guard
        let currentUser = storage.firstObject(
          of: UserProfileEntity.self,
          matching: PredicateProvider.userProfileById(userID)),
        !currentUser.goals.isEmpty
      else {
        return
      }

      for goal in currentUser.goals {
        guard let category = goal.category else {
          continue
        }

        if
          let mappedCategories = ExerciseConstants.goalToExerciseCategories[category],
          mappedCategories.contains(exerciseSession.exercise.category)
        {
          let progressEntry = storage.insertNewObject(ofType: ProgressEntryEntity.self)
          progressEntry.progressID = UUID()
          progressEntry.dateAdded = Date()
          progressEntry.goal = goal
          progressEntry.value = 1 as NSNumber
        }
      }
    }
  }

  public func goalByID(_ goalID: UUID) async -> Goal? {
    await getFirstObject(GoalEntity.self, predicate: PredicateProvider.goalByID(goalID))
  }

  public func insertProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws {
    try await storageManager.performWrite { storage in
      guard let goal = storage.firstObject(of: GoalEntity.self, matching: PredicateProvider.goalByID(goalID)) else {
        throw MusculosError.unexpectedNil
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

extension CoreDataStore {
  public func exerciseSessionsForUser(_ userID: UUID) async -> [ExerciseSession] {
    await getAll(ExerciseSessionEntity.self, predicate: PredicateProvider.exerciseSessionsForUser(userID))
  }

  public func exerciseSessionCompletedToday(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getCurrentDayRange() as? (Date, Date) else {
      return []
    }

    let userPredicate = PredicateProvider.exerciseSessionsForUser(userID)
    let datePredicate = PredicateProvider.exerciseSessionsBetweenDates(startDay, endDate: endDay)
    let compundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

    return await getAll(ExerciseSessionEntity.self, predicate: compundPredicate)
  }

  public func exerciseSessionsCompletedSinceLastWeek(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date) else {
      return []
    }

    let userPredicate = PredicateProvider.exerciseSessionsForUser(userID)
    let datePredicate = PredicateProvider.exerciseSessionsBetweenDates(startDay, endDate: endDay)
    let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [userPredicate, datePredicate])

    return await getAll(ExerciseSessionEntity.self, predicate: compoundPredicate)
  }

  public func exerciseSessionByID(_ id: UUID) async -> ExerciseSession? {
    await getFirstObject(ExerciseSessionEntity.self, predicate: PredicateProvider.exerciseSessionByID(id))
  }
}

// MARK: - Exercise

extension CoreDataStore {
  public func exerciseByID(_ exerciseID: UUID) async -> Exercise? {
    await getFirstObject(ExerciseEntity.self, predicate: PredicateProvider.exerciseById(exerciseID))
  }

  public func exerciseRecommendationsByHistory(for _: UUID) async -> [Exercise] {
    await storageManager.performRead { storage in
      let exerciseSessions = storage
        .allObjects(ofType: ExerciseSessionEntity.self, matching: nil, sortedBy: nil)
        .map { $0.toReadOnly() }

      let muscles = Array(Set(exerciseSessions.flatMap { $0.exercise.muscleTypes }))
      let muscleIds = muscles.map { $0.id }

      return storage.allObjects(
        ofType: PrimaryMuscleEntity.self,
        matching: NSPredicate(format: "NOT (muscleID IN %@)", muscleIds),
        sortedBy: nil)
        .flatMap { $0.exercises }
        .map { $0.toReadOnly() }
    }
  }

  public func favoriteExercises(for _: UUID) async -> [Exercise] {
    await getAll(ExerciseEntity.self, predicate: PredicateProvider.favoriteExercise())
  }

  public func exercisesByQuery(_ nameQuery: String) async -> [Exercise] {
    await getAll(ExerciseEntity.self, predicate: PredicateProvider.exerciseByName(nameQuery))
  }

  public func exercisesForMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { storage in
      let muscleIds = muscles.map { $0.id }

      return storage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: PredicateProvider.musclesByIds(muscleIds),
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForGoals(_ goals: [Goal], fetchLimit: Int = 50) async -> [Exercise] {
    await getAll(ExerciseEntity.self, fetchLimit: fetchLimit, predicate: PredicateProvider.exerciseByGoals(goals))
  }

  public func exercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }

      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: NSPredicate(format: "NOT (muscleID IN %@)", muscleIds),
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForWorkoutGoal(_ workoutGoal: WorkoutGoal) async -> [Exercise] {
    let mappedCategories = workoutGoal.goalCategory.mappedExerciseCategories.map { $0.rawValue }
    return await getAll(ExerciseEntity.self, predicate: PredicateProvider.exerciseByCategories(mappedCategories))
  }

  public func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { storage in
      guard let exercise = storage.firstObject(of: ExerciseEntity.self, matching: PredicateProvider.exerciseById(exercise.id))
      else {
        throw MusculosError.unexpectedNil
      }

      exercise.isFavorite = isFavorite
      storage.saveIfNeeded()
    }
  }
}

// MARK: - Workout

extension CoreDataStore {
  public func workout(by id: UUID) async -> Workout? {
    await getFirstObject(WorkoutEntity.self, predicate: PredicateProvider.workoutByID(id))
  }

  public func insertWorkout(_ workout: Workout) async throws {
    try await importModel(workout, of: WorkoutEntity.self)
  }
}

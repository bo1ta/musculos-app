//
//  CoreDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import CoreData
import Factory
import Foundation
import Models
import Principle
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

  public func entityPublisher<T: EntityType>(matching predicate: NSPredicate) -> EntityPublisher<T> {
    EntityPublisher(storage: storageManager.writerDerivedStorage, predicate: predicate)
  }

  public func fetchedResultsPublisher<T: EntityType>(
    matching predicate: NSPredicate? = nil,
    sortDescriptors: [NSSortDescriptor] = [],
    fetchLimit: Int? = 10)
    -> FetchedResultsPublisher<T>
  {
    FetchedResultsPublisher(
      storage: storageManager.viewStorage,
      sortDescriptors: sortDescriptors,
      predicate: predicate,
      fetchLimit: fetchLimit)
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
    let predicate: NSPredicate = \UserProfileEntity.userId == userID
    return await getFirstObject(UserProfileEntity.self, predicate: predicate)
  }

  public func userProfileByEmail(_ email: String) async -> UserProfile? {
    let predicate: NSPredicate = \UserProfileEntity.email == email
    return await getFirstObject(UserProfileEntity.self, predicate: predicate)
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
    try await storageManager.performWrite { storage in
      guard let userProfile = Self.userProfileEntity(byID: userId, on: storage) else {
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

  public func userPublisherForID(_ userID: UUID) -> EntityPublisher<UserProfileEntity> {
    entityPublisher(matching: \UserProfileEntity.userId == userID)
  }

  private static func userProfileEntity(byID userID: UUID, on storage: StorageType) -> UserProfileEntity? {
    storage.firstObject(of: UserProfileEntity.self, matching: \UserProfileEntity.userId == userID)
  }
}

// MARK: - User Experience

extension CoreDataStore {
  public func userExperienceEntryByID(_ id: UUID) async -> UserExperienceEntry? {
    await getFirstObject(UserExperienceEntryEntity.self, predicate: \UserExperienceEntryEntity.modelID == id)
  }

  public func userExperienceForUserID(_ userID: UUID) async -> UserExperience? {
    await storageManager.performRead { storage in
      guard
        let userProfile = Self.userProfileEntity(byID: userID, on: storage),
        let experience = userProfile.userExperience
      else {
        return nil
      }

      return experience.toReadOnly()
    }
  }
}

// MARK: - ExerciseHelper

enum ExerciseHelper {
  static func exerciseMatchesGoal(_ exercise: Exercise, goal: Goal) -> Bool {
    guard
      let category = goal.category,
      let mappedCategories = ExerciseConstants.goalToExerciseCategories[category]
    else {
      return false
    }
    return mappedCategories.contains(exercise.category)
  }
}

// MARK: - Goal

extension CoreDataStore {
  public func updateGoalProgress(userID: UUID, exerciseSession: ExerciseSession) async throws {
    try await storageManager.performWrite { storage in
      guard let currentUser = Self.userProfileEntity(byID: userID, on: storage), !currentUser.goals.isEmpty else {
        return
      }

      currentUser.goals
        .filter { goal in
          guard
            let category = goal.category,
            let mappedCategories = ExerciseConstants.goalToExerciseCategories[category]
          else {
            return false
          }
          return mappedCategories.contains(exerciseSession.exercise.category)
        }
        .forEach { goal in
          let progressEntry = storage.insertNewObject(ofType: ProgressEntryEntity.self)
          progressEntry.progressID = UUID()
          progressEntry.dateAdded = Date()
          progressEntry.goal = goal
          progressEntry.value = 1 as NSNumber
        }
    }
  }

  public func goalByID(_ goalID: UUID) async -> Goal? {
    let predicate: NSPredicate = \GoalEntity.goalID == goalID
    return await getFirstObject(GoalEntity.self, predicate: predicate)
  }

  public func insertProgressEntry(_ progressEntry: ProgressEntry, for goalID: UUID) async throws {
    try await storageManager.performWrite { storage in
      let predicate: NSPredicate = \GoalEntity.goalID == goalID
      guard let goal = storage.firstObject(of: GoalEntity.self, matching: predicate) else {
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
    let predicate: NSPredicate = \ExerciseSessionEntity.user.userId == userID
    return await getAll(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionCompletedToday(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getCurrentDayRange() as? (Date, Date) else {
      return []
    }

    let predicate: NSPredicate = \ExerciseSessionEntity.user.userId == userID && \.dateAdded >= startDay && \.dateAdded <= endDay
    return await getAll(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionsCompletedSinceLastWeek(for userID: UUID) async -> [ExerciseSession] {
    guard let (startDay, endDay) = DateHelper.getPastWeekRange() as? (Date, Date) else {
      return []
    }

    let predicate: NSPredicate = \ExerciseSessionEntity.user.userId == userID && \.dateAdded >= startDay && \.dateAdded <= endDay
    return await getAll(ExerciseSessionEntity.self, predicate: predicate)
  }

  public func exerciseSessionByID(_ id: UUID) async -> ExerciseSession? {
    let predicate: NSPredicate = \ExerciseSessionEntity.sessionId == id
    return await getFirstObject(ExerciseSessionEntity.self, predicate: predicate)
  }
}

// MARK: - Route Exercise Session

extension CoreDataStore {
  public func routeExerciseSessionByID(_ id: UUID) async -> RouteExerciseSession? {
    let predicate: NSPredicate = \RouteExerciseSessionEntity.uuid == id
    return await getFirstObject(RouteExerciseSessionEntity.self, predicate: predicate)
  }

  public func routeExerciseSessionsForUserID(_ userID: UUID) async -> [RouteExerciseSession] {
    let predicate: NSPredicate = \RouteExerciseSessionEntity.userID == userID
    return await getAll(RouteExerciseSessionEntity.self, predicate: predicate)
  }
}

// MARK: - Exercise

extension CoreDataStore {
  public func exerciseByID(_ exerciseID: UUID) async -> Exercise? {
    let predicate: NSPredicate = \ExerciseEntity.exerciseId == exerciseID
    return await getFirstObject(ExerciseEntity.self, predicate: predicate)
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
    let predicate: NSPredicate = \ExerciseEntity.isFavorite == true
    return await getAll(ExerciseEntity.self, predicate: predicate)
  }

  public func exercisesByQuery(_ nameQuery: String) async -> [Exercise] {
    let predicate: NSPredicate = \ExerciseEntity.name | contains(nameQuery)
    return await getAll(ExerciseEntity.self, predicate: predicate)
  }

  public func exercisesForMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { storage in
      let muscleIDs = muscles.map { $0.id }
      let predicate = NSPredicate(
        format: "%K IN %@",
        #keyPath(PrimaryMuscleEntity.muscleID),
        muscleIDs)
      return storage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: predicate,
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForGoals(_ goals: [Goal], fetchLimit: Int = 50) async -> [Exercise] {
    var predicate: NSPredicate?

    for goal in goals {
      if let categories = ExerciseConstants.goalToExerciseCategories[goal.category ?? ""] {
        let categoryPredicate = NSPredicate(
          format: "%K IN %@",
          #keyPath(ExerciseEntity.category),
          categories)

        predicate =
          if predicate == nil {
            categoryPredicate
          } else {
            NSCompoundPredicate(orPredicateWithSubpredicates: [
              predicate!, // swiftlint:disable:this force_unwrapping
              categoryPredicate,
            ])
          }
      }
    }

    return await getAll(ExerciseEntity.self, fetchLimit: fetchLimit, predicate: predicate)
  }

  public func exercisesExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    await storageManager.performRead { viewStorage in
      let muscleIds = muscles.map { $0.id }
      let predicate = NSPredicate(format: "NOT (muscleID IN %@)", muscleIds)

      return viewStorage
        .allObjects(
          ofType: PrimaryMuscleEntity.self,
          matching: predicate,
          sortedBy: nil)
        .flatMap(\.exercises)
        .map { $0.toReadOnly() }
    }
  }

  public func exercisesForWorkoutGoal(_ workoutGoal: WorkoutGoal) async -> [Exercise] {
    let categories = workoutGoal.goalCategory.mappedExerciseCategories.map { $0.rawValue }
    let predicate = NSPredicate(format: "%K IN %@", #keyPath(ExerciseEntity.category), categories)
    return await getAll(ExerciseEntity.self, predicate: predicate)
  }

  public func favoriteExercise(_ exercise: Exercise, isFavorite: Bool) async throws {
    try await storageManager.performWrite { storage in
      let predicate: NSPredicate = \ExerciseEntity.exerciseId == exercise.id
      guard let exercise = storage.firstObject(of: ExerciseEntity.self, matching: predicate) else {
        throw MusculosError.unexpectedNil
      }

      exercise.isFavorite = isFavorite
      storage.saveIfNeeded()
    }
  }

  public func exercisePublisherForID(_ exerciseID: UUID) -> EntityPublisher<ExerciseEntity> {
    entityPublisher(matching: \ExerciseEntity.exerciseId == exerciseID)
  }
}

// MARK: - Workout

extension CoreDataStore {
  public func workout(by id: UUID) async -> Workout? {
    let predicate: NSPredicate = \WorkoutEntity.modelID == id
    return await getFirstObject(WorkoutEntity.self, predicate: predicate)
  }

  public func insertWorkout(_ workout: Workout) async throws {
    try await importModel(workout, of: WorkoutEntity.self)
  }
}

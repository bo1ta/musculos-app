//
//  UserProfileEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.07.2024.
//
//

import CoreData
import Foundation
import Principle
import Principle
import Models

// MARK: - UserProfileEntity

@objc(UserProfileEntity)
public class UserProfileEntity: NSManagedObject {
  @NSManaged public var userId: UUID
  @NSManaged public var availableEquipment: [String]?
  @NSManaged public var avatarUrl: String?
  @NSManaged public var email: String
  @NSManaged public var fullName: String?
  @NSManaged public var gender: String?
  @NSManaged public var height: NSNumber?
  @NSManaged public var level: String?
  @NSManaged public var primaryGoalID: UUID?
  @NSManaged public var synchronized: NSNumber
  @NSManaged public var updatedAt: Date?
  @NSManaged public var username: String
  @NSManaged public var weight: NSNumber?
  @NSManaged public var isOnboarded: Bool
  @NSManaged public var xp: NSNumber // swiftlint:disable:this identifier_name
  @NSManaged public var goals: Set<GoalEntity>
  @NSManaged public var exerciseSessions: Set<ExerciseSessionEntity>
  @NSManaged public var ratings: Set<ExerciseRatingEntity>
  @NSManaged public var userExperience: UserExperienceEntity?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
    NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
  }

  public var synchronizationState: SynchronizationState {
    get {
      SynchronizationState(rawValue: synchronized.intValue) ?? .notSynchronized
    }

    set {
      synchronized = newValue.rawValue as NSNumber
    }
  }
}

// MARK: - Generated accessors for relationships

extension UserProfileEntity {
  @objc(addExerciseSessionsObject:)
  @NSManaged
  public func addToExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(removeExerciseSessionsObject:)
  @NSManaged
  public func removeFromExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(addExerciseSessions:)
  @NSManaged
  public func addToExerciseSessions(_ values: NSSet)

  @objc(removeExerciseSessions:)
  @NSManaged
  public func removeFromExerciseSessions(_ values: NSSet)

  @objc(addGoalsObject:)
  @NSManaged
  public func addToGoals(_ value: GoalEntity)

  @objc(removeFromGoalsObject:)
  @NSManaged
  public func removeFromGoals(_ value: GoalEntity)

  @objc(addGoals:)
  @NSManaged
  public func addToGoals(_ values: NSSet)

  @objc(removeGoals:)
  @NSManaged
  public func removeFromGoals(_ values: NSSet)

  @objc(addExerciseRatingsObject:)
  @NSManaged
  public func addToExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(removeExerciseRatingsObject:)
  @NSManaged
  public func removeFromExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(addExerciseRatings:)
  @NSManaged
  public func addToExerciseRatings(_ values: NSSet)

  @objc(removeExerciseRatings:)
  @NSManaged
  public func removeFromExerciseRatings(_ values: NSSet)
}

// MARK: ReadOnlyConvertible

extension UserProfileEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserProfile {
    UserProfile(
      userId: userId,
      email: email,
      username: username,
      weight: weight?.doubleValue,
      height: height?.doubleValue,
      level: level,
      availableEquipment: availableEquipment,
      primaryGoalID: primaryGoalID,
      isOnboarded: isOnboarded,
      xp: xp.intValue,
      ratings: ratings.map { $0.toReadOnly() })
  }
}

// MARK: - Common predicate

extension UserProfileEntity {
  static func entityFrom(_ model: UserProfile, using storage: StorageType) -> UserProfileEntity {
    let predicate: NSPredicate = \UserProfileEntity.userId == model.userId

    if let userProfile = storage.firstObject(of: UserProfileEntity.self, matching: predicate) {
      return userProfile
    } else {
      let userProfile = storage.insertNewObject(ofType: UserProfileEntity.self)
      userProfile.populateEntityFrom(model, using: storage)
      return userProfile
    }
  }
}

// MARK: EntitySyncable

extension UserProfileEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserProfile, using storage: StorageType) {
    userId = model.userId
    availableEquipment = model.availableEquipment
    avatarUrl = model.avatar
    email = model.email
    fullName = model.fullName
    gender = model.gender
    level = model.level
    username = model.username
    isOnboarded = model.isOnboarded ?? false
    xp = (model.xp ?? 0) as NSNumber
    ratings = Set<ExerciseRatingEntity>()

    if let weight = model.weight {
      self.weight = weight as NSNumber
    }

    if let height = model.height {
      self.height = height as NSNumber
    }

    if let primaryGoalID = model.primaryGoalID {
      self.primaryGoalID = primaryGoalID
    }

    if let userExperience = model.userExperience {
      let predicate: NSPredicate = \UserExperienceEntity.modelID == userExperience.id
      let userExperienceEntity = storage.findOrInsert(of: UserExperienceEntity.self, using: predicate)

      userExperienceEntity.populateEntityFrom(userExperience, using: storage)
      userExperienceEntity.user = self
      self.userExperience = userExperienceEntity
    }

    synchronized = SynchronizationState.synchronized.asNSNumber()
  }

  public func updateEntityFrom(_ model: UserProfile, using storage: any StorageType) {
    avatarUrl = model.avatar
    isOnboarded = model.isOnboarded ?? false

    if let weight = model.weight {
      self.weight = weight as NSNumber
    }

    if let height = model.height {
      self.height = height as NSNumber
    }

    if let primaryGoalID = model.primaryGoalID {
      self.primaryGoalID = primaryGoalID
    }

    // swiftlint:disable:next identifier_name
    if let xp = model.xp, xp > self.xp.intValue {
      self.xp = xp as NSNumber
    }

    synchronized = SynchronizationState.synchronized.asNSNumber()

    if let goals = model.goals {
      var goalsSet = Set<GoalEntity>()

      for goal in goals {
        let predicate: NSPredicate = \GoalEntity.goalID == goal.id
        let goalEntity = storage.findOrInsert(of: GoalEntity.self, using: predicate)
        goalEntity.updateEntityFrom(goal, using: storage)
        goalsSet.insert(goalEntity)
      }

      self.goals = goalsSet
    }
  }
}

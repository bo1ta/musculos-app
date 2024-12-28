//
//  UserProfileEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.07.2024.
//
//

import CoreData
import Foundation
import Models

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
  @NSManaged public var exerciseRatings: Set<ExerciseRatingEntity>
  @NSManaged public var userExperience: UserExperienceEntity?

  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
    return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
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

public extension UserProfileEntity {
  @objc(addExerciseSessionsObject:)
  @NSManaged func addToExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(removeExerciseSessionsObject:)
  @NSManaged func removeFromExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(addExerciseSessions:)
  @NSManaged func addToExerciseSessions(_ values: NSSet)

  @objc(removeExerciseSessions:)
  @NSManaged func removeFromExerciseSessions(_ values: NSSet)

  @objc(addGoalsObject:)
  @NSManaged func addToGoals(_ value: GoalEntity)

  @objc(removeFromGoalsObject:)
  @NSManaged func removeFromGoals(_ value: GoalEntity)

  @objc(addGoals:)
  @NSManaged func addToGoals(_ values: NSSet)

  @objc(removeGoals:)
  @NSManaged func removeFromGoals(_ values: NSSet)

  @objc(addExerciseRatingsObject:)
  @NSManaged func addToExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(removeExerciseRatingsObject:)
  @NSManaged func removeFromExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(addExerciseRatings:)
  @NSManaged func addToExerciseRatings(_ values: NSSet)

  @objc(removeExerciseRatings:)
  @NSManaged func removeFromExerciseRatings(_ values: NSSet)
}

// MARK: - ReadOnlyConvertible

extension UserProfileEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserProfile {
    return UserProfile(
      userId: userId,
      email: email,
      username: username,
      weight: weight?.doubleValue,
      height: height?.doubleValue,
      level: level,
      availableEquipment: availableEquipment,
      primaryGoalID: primaryGoalID,
      isOnboarded: isOnboarded,
      xp: xp.intValue
    )
  }
}

// MARK: - Common predicate

extension UserProfileEntity {
  static func userFromID(_ userID: UUID, on storage: StorageType) -> UserProfileEntity? {
    return storage.firstObject(of: UserProfileEntity.self, matching: PredicateProvider.userProfileById(userID))
  }

  static func currentUser() -> UserProfileEntity? {
    guard let currentUserID = StorageContainer.shared.userManager().currentUserID else {
      return nil
    }
    return userFromID(currentUserID, on: StorageContainer.shared.storageManager().viewStorage)
  }

  static func entityFrom(_ model: UserProfile, using storage: StorageType) -> UserProfileEntity {
    if let userProfile = userFromID(model.userId, on: storage) {
      return userProfile
    } else {
      let userProfile = storage.insertNewObject(ofType: UserProfileEntity.self)
      userProfile.populateEntityFrom(model, using: storage)
      return userProfile
    }
  }
}

// MARK: - EntitySyncable

extension UserProfileEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserProfile, using _: StorageType) {
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

    if let weight = model.weight {
      self.weight = weight as NSNumber
    }
    if let height = model.height {
      self.height = height as NSNumber
    }
    if let primaryGoalID = model.primaryGoalID {
      self.primaryGoalID = primaryGoalID
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
        let goalEntity = storage.findOrInsert(
          of: GoalEntity.self,
          using: PredicateProvider.goalByID(goal.id)
        )
        goalEntity.updateEntityFrom(goal, using: storage)
        goalsSet.insert(goalEntity)
      }

      self.goals = goalsSet
    }
  }
}

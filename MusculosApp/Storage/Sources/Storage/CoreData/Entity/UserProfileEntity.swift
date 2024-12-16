//
//  UserProfileEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.07.2024.
//
//

import Foundation
import CoreData
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
  @NSManaged public var xp: NSNumber
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
      synchronized = NSNumber(integerLiteral: newValue.rawValue)
    }
  }
}

// MARK: - Generated accessors for relationships

extension UserProfileEntity {

  @objc(addExerciseSessionsObject:)
  @NSManaged public func addToExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(removeExerciseSessionsObject:)
  @NSManaged public func removeFromExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(addExerciseSessions:)
  @NSManaged public func addToExerciseSessions(_ values: NSSet)

  @objc(removeExerciseSessions:)
  @NSManaged public func removeFromExerciseSessions(_ values: NSSet)

  @objc(addGoalsObject:)
  @NSManaged public func addToGoals(_ value: GoalEntity)

  @objc(removeFromGoalsObject:)
  @NSManaged public func removeFromGoals(_ value: GoalEntity)

  @objc(addGoals:)
  @NSManaged public func addToGoals(_ values: NSSet)

  @objc(removeGoals:)
  @NSManaged public func removeFromGoals(_ values: NSSet)

  @objc(addExerciseRatingsObject:)
  @NSManaged public func addToExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(removeExerciseRatingsObject:)
  @NSManaged public func removeFromExerciseRatings(_ value: ExerciseRatingEntity)

  @objc(addExerciseRatings:)
  @NSManaged public func addToExerciseRatings(_ values: NSSet)

  @objc(removeExerciseRatings:)
  @NSManaged public func removeFromExerciseRatings(_ values: NSSet)

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
}

// MARK: - EntitySyncable

extension UserProfileEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserProfile, using storage: StorageType) {
    self.userId = model.userId
    self.availableEquipment = model.availableEquipment
    self.avatarUrl = model.avatar
    self.email = model.email
    self.fullName = model.fullName
    self.gender = model.gender
    self.level = model.level
    self.username = model.username
    self.isOnboarded = model.isOnboarded ?? false
    self.xp = NSNumber(integerLiteral: model.xp ?? 0)

    if let weight = model.weight {
      self.weight = NSNumber(floatLiteral: weight)
    }
    if let height = model.height {
      self.height = NSNumber(floatLiteral: height)
    }
    if let primaryGoalID = model.primaryGoalID {
      self.primaryGoalID = primaryGoalID
    }

    self.synchronized = SynchronizationState.synchronized.asNSNumber()
  }

  public func updateEntityFrom(_ model: UserProfile, using storage: any StorageType) {
    self.avatarUrl = model.avatar
    self.isOnboarded = model.isOnboarded ?? false

    if let weight = model.weight {
      self.weight = NSNumber(floatLiteral: weight)
    }
    if let height = model.height {
      self.height = NSNumber(floatLiteral: height)
    }
    if let primaryGoalID = model.primaryGoalID {
      self.primaryGoalID = primaryGoalID
    }
    if let xp = model.xp, xp > self.xp.intValue {
      self.xp = NSNumber(integerLiteral: xp)
    }

    self.synchronized = SynchronizationState.synchronized.asNSNumber()

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

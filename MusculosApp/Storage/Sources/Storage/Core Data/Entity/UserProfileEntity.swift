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
  @NSManaged public var email: String?
  @NSManaged public var fullName: String?
  @NSManaged public var gender: String?
  @NSManaged public var height: NSNumber?
  @NSManaged public var level: String?
  @NSManaged public var primaryGoalId: NSNumber?
  @NSManaged public var synchronized: NSNumber
  @NSManaged public var updatedAt: Date?
  @NSManaged public var username: String?
  @NSManaged public var weight: NSNumber?
  @NSManaged public var exerciseSessions: Set<ExerciseSessionEntity>

  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
    return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
  }
}

// MARK: Generated accessors for exerciseSessions
extension UserProfileEntity {

  @objc(addExerciseSessionsObject:)
  @NSManaged public func addToExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(removeExerciseSessionsObject:)
  @NSManaged public func removeFromExerciseSessions(_ value: ExerciseSessionEntity)

  @objc(addExerciseSessions:)
  @NSManaged public func addToExerciseSessions(_ values: NSSet)

  @objc(removeExerciseSessions:)
  @NSManaged public func removeFromExerciseSessions(_ values: NSSet)

}

// MARK: - ReadOnlyConvertible impl

extension UserProfileEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserProfile? {
    guard let email, let username else { return nil }

    return UserProfile(
      userId: userId,
      email: email,
      username: username,
      weight: weight?.doubleValue,
      height: height?.doubleValue,
      level: level,
      availableEquipment: availableEquipment,
      primaryGoalId: primaryGoalId?.intValue
    )
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

// MARK: - Common predicate

extension UserProfileEntity {
  static func userFrom(userId: String, on storage: StorageType) -> UserProfileEntity? {
    return storage.firstObject(of: UserProfileEntity.self, matching: CommonPredicate.currentUser(userId).nsPredicate)
  }

  enum CommonPredicate {
    case currentUser(String)

    var nsPredicate: NSPredicate {
      switch self {
      case .currentUser(let userId):
        NSPredicate(
          format: "%K == %@",
          #keyPath(UserProfileEntity.userId),
          userId
        )
      }
    }
  }
}

// MARK: - EntitySyncable

extension UserProfileEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserProfile, using storage: StorageType) throws {
    self.userId = model.userId
    self.availableEquipment = model.availableEquipment
    self.avatarUrl = model.avatar
    self.email = model.email
    self.fullName = model.fullName
    self.gender = model.gender
    self.level = model.level
    self.username = model.username

    if let weight = model.weight {
      self.weight = NSNumber(floatLiteral: weight)
    }
    if let height = model.height {
      self.height = NSNumber(floatLiteral: height)
    }
    if let primaryGoalId = model.primaryGoalId {
      self.primaryGoalId = NSNumber(integerLiteral: primaryGoalId)
    }

    self.synchronized = SynchronizationState.synchronized.asNSNumber()
  }
  
  public func updateEntityFrom(_ model: UserProfile, using storage: any StorageType) throws {
    self.avatarUrl = model.avatar

    if let weight = model.weight {
      self.weight = NSNumber(floatLiteral: weight)
    }
    if let height = model.height {
      self.height = NSNumber(floatLiteral: height)
    }
    if let primaryGoalId = model.primaryGoalId {
      self.primaryGoalId = NSNumber(integerLiteral: primaryGoalId)
    }

    self.synchronized = SynchronizationState.synchronized.asNSNumber()
  }
}

//
//  UserProfileEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.07.2024.
//
//

import Foundation
import CoreData
import Models

extension UserProfileEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfileEntity> {
    return NSFetchRequest<UserProfileEntity>(entityName: "UserProfileEntity")
  }
  
  @NSManaged public var userId: String?
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
  func toReadOnly() -> UserProfile? {
    guard let email, let username, let userId else { return nil }
    
    return UserProfile(userId: UUID(uuidString: userId)!, email: email, username: username, weight: weight?.doubleValue, height: height?.doubleValue, level: level, availableEquipment: availableEquipment, primaryGoalId: primaryGoalId?.intValue)
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

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
  
  public var synchronizationState: SynchronizationState {
    get {
      SynchronizationState(rawValue: synchronized.intValue) ?? .notSynchronized
    }
    
    set {
      synchronized = NSNumber(integerLiteral: newValue.rawValue)
    }
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
  func toReadOnly() -> UserProfile? {
    guard let email, let username else { return nil }
    
    return UserProfile(userId: userId, email: email, username: username, weight: weight?.doubleValue, height: height?.doubleValue, level: level, availableEquipment: availableEquipment, primaryGoalId: primaryGoalId?.intValue)
  }
}

// MARK: - Common predicate

extension UserProfileEntity {
  enum CommonPredicate {
    case currentUser(UUID)
    
    var nsPredicate: NSPredicate {
      switch self {
      case .currentUser(let uuid):
        NSPredicate(
          format: "%K == %@",
          #keyPath(UserProfileEntity.userId),
          uuid.uuidString
        )
      }
    }
  }
}

//
//  UserEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.04.2024.
//
//

import Foundation
import CoreData


extension UserEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
    return NSFetchRequest<UserEntity>(entityName: "UserEntity")
  }
  
  @NSManaged public var gender: String?
  @NSManaged public var fullName: String?
  @NSManaged public var username: String
  @NSManaged public var email: String
  @NSManaged public var avatarUrl: String?
  @NSManaged public var weight: NSNumber?
  @NSManaged public var height: NSNumber?
  @NSManaged public var primaryGoalId: NSNumber?
  @NSManaged public var isCurrentUser: Bool
  @NSManaged public var isOnboarded: Bool
  @NSManaged public var synchronized: NSNumber
  @NSManaged public var updatedAt: Date
  @NSManaged public var level: String?
  @NSManaged public var availableEquipment: [String]?
}

extension UserEntity : Identifiable {}

// MARK: - ReadOnlyConvertible impl

extension UserEntity: ReadOnlyConvertible {
  func toReadOnly() -> User {
    return User(
      email: self.email,
      fullName: self.fullName,
      username: self.username,
      avatar: self.avatarUrl,
      isOnboarded: self.isOnboarded,
      gender: self.gender,
      weight: self.weight?.doubleValue,
      height: self.height?.doubleValue,
      level: self.level,
      availableEquipment: self.availableEquipment,
      primaryGoalId: self.primaryGoalId?.intValue
    )
  }
}

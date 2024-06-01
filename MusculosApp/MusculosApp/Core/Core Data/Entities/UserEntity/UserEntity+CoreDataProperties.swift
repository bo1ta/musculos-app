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
  @NSManaged public var username: String?
  @NSManaged public var email: String?
  @NSManaged public var weight: NSNumber?
  @NSManaged public var height: NSNumber?
  @NSManaged public var goalId: NSNumber?
  @NSManaged public var isCurrentUser: Bool
  @NSManaged public var synchronized: NSNumber
  @NSManaged public var updatedAt: Date
}

extension UserEntity : Identifiable {}

// MARK: - ReadOnlyConvertible impl

extension UserEntity: ReadOnlyConvertible {
  func toReadOnly() -> Person {
    return Person(
      email: self.email ?? "",
      fullName: self.fullName,
      username: self.username ?? "",
      avatar: ""
    )
  }
}

//
//  UserExperienceEntryEntity.swift
//
//
//  Created by Solomon Alexandru on 15.12.2024.
//
//

import CoreData
import Foundation
import Models
import Principle

// MARK: - UserExperienceEntryEntity

@objc(UserExperienceEntryEntity)
public class UserExperienceEntryEntity: NSManagedObject {
  @NSManaged public var uniqueID: UUID
  @NSManaged public var xpGained: NSNumber
  @NSManaged public var userExperience: UserExperienceEntity

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<UserExperienceEntryEntity> {
    NSFetchRequest<UserExperienceEntryEntity>(entityName: "UserExperienceEntryEntity")
  }
}

// MARK: ReadOnlyConvertible

extension UserExperienceEntryEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserExperienceEntry {
    UserExperienceEntry(
      id: uniqueID,
      userExperience: userExperience.toReadOnly(),
      xpGained: xpGained.intValue)
  }
}

// MARK: EntitySyncable

extension UserExperienceEntryEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserExperienceEntry, using storage: any StorageType) {
    uniqueID = model.id
    xpGained = model.xpGained as NSNumber

    if
      let userExperienceEntity = storage.firstObject(
        of: UserExperienceEntity.self,
        matching: \UserExperienceEntryEntity.uniqueID == model.userExperience.id)
    {
      userExperience = userExperienceEntity
    }
  }

  public func updateEntityFrom(_ model: UserExperienceEntry, using _: any StorageType) {
    xpGained = model.xpGained as NSNumber
  }
}

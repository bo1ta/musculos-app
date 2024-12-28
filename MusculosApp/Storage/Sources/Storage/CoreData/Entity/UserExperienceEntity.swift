//
//  UserExperienceEntity.swift
//
//
//  Created by Solomon Alexandru on 15.12.2024.
//
//

import CoreData
import Foundation
import Models

@objc(UserExperienceEntity)
public class UserExperienceEntity: NSManagedObject {
  @NSManaged public var modelID: UUID
  @NSManaged public var totalExperience: NSNumber
  @NSManaged public var user: UserProfileEntity?
  @NSManaged public var experienceEntries: Set<UserExperienceEntryEntity>

  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserExperienceEntity> {
    return NSFetchRequest<UserExperienceEntity>(entityName: "UserExperienceEntity")
  }
}

public extension UserExperienceEntity {
  @objc(addExperienceEntriesObject:)
  @NSManaged func addToExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(removeExperienceEntriesObject:)
  @NSManaged func removeFromExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(addExperienceEntries:)
  @NSManaged func addToExperienceEntries(_ values: Set<UserExperienceEntryEntity>)

  @objc(removeExperienceEntries:)
  @NSManaged func removeFromExperienceEntries(_ values: Set<UserExperienceEntryEntity>)
}

extension UserExperienceEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserExperience {
    return UserExperience(
      id: modelID,
      totalExperience: totalExperience.intValue,
      experienceEntries: experienceEntries.map { $0.toReadOnly() }
    )
  }
}

extension UserExperienceEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserExperience, using _: any StorageType) {
    modelID = model.id
    totalExperience = model.totalExperience as NSNumber
    experienceEntries = Set<UserExperienceEntryEntity>()
  }

  public func updateEntityFrom(_ model: UserExperience, using _: any StorageType) {
    totalExperience = model.totalExperience as NSNumber
  }
}

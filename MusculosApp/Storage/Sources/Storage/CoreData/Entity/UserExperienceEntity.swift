//
//  UserExperienceEntity.swift
//
//
//  Created by Solomon Alexandru on 15.12.2024.
//
//

import Foundation
import CoreData
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

extension UserExperienceEntity {
  @objc(addExperienceEntriesObject:)
  @NSManaged public func addToExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(removeExperienceEntriesObject:)
  @NSManaged public func removeFromExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(addExperienceEntries:)
  @NSManaged public func addToExperienceEntries(_ values: Set<UserExperienceEntryEntity>)

  @objc(removeExperienceEntries:)
  @NSManaged public func removeFromExperienceEntries(_ values: Set<UserExperienceEntryEntity>)
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
  public func populateEntityFrom(_ model: UserExperience, using storage: any StorageType) {
    modelID = model.id
    totalExperience = NSNumber(integerLiteral: model.totalExperience)
    experienceEntries = Set<UserExperienceEntryEntity>()
  }

  public func updateEntityFrom(_ model: UserExperience, using storage: any StorageType) {
    totalExperience = NSNumber(integerLiteral: model.totalExperience)
  }
}

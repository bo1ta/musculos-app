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
import Principle

// MARK: - UserExperienceEntity

@objc(UserExperienceEntity)
public class UserExperienceEntity: NSManagedObject {
  @NSManaged public var uniqueID: UUID
  @NSManaged public var totalExperience: NSNumber
  @NSManaged public var user: UserProfileEntity?
  @NSManaged public var experienceEntries: Set<UserExperienceEntryEntity>

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<UserExperienceEntity> {
    NSFetchRequest<UserExperienceEntity>(entityName: "UserExperienceEntity")
  }
}

extension UserExperienceEntity {
  @objc(addExperienceEntriesObject:)
  @NSManaged
  public func addToExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(removeExperienceEntriesObject:)
  @NSManaged
  public func removeFromExperienceEntries(_ value: UserExperienceEntryEntity)

  @objc(addExperienceEntries:)
  @NSManaged
  public func addToExperienceEntries(_ values: Set<UserExperienceEntryEntity>)

  @objc(removeExperienceEntries:)
  @NSManaged
  public func removeFromExperienceEntries(_ values: Set<UserExperienceEntryEntity>)
}

// MARK: ReadOnlyConvertible

extension UserExperienceEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserExperience {
    UserExperience(
      id: uniqueID,
      totalExperience: totalExperience.intValue)
  }
}

// MARK: EntitySyncable

extension UserExperienceEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserExperience, using _: any StorageType) {
    uniqueID = model.id
    totalExperience = model.totalExperience as NSNumber
    experienceEntries = Set<UserExperienceEntryEntity>()
  }

  public func updateEntityFrom(_ model: UserExperience, using storage: any StorageType) {
    totalExperience = model.totalExperience as NSNumber

    guard let experienceEntries = model.experienceEntries else {
      return
    }

    let entities = experienceEntries.map { experienceEntry in
      let entity = storage.findOrInsert(
        of: UserExperienceEntryEntity.self,
        using: \UserExperienceEntryEntity.uniqueID == experienceEntry.id)
      entity.populateEntityFrom(experienceEntry, using: storage)
      entity.userExperience = self
      return entity
    }
    addToExperienceEntries(Set(entities))
  }
}

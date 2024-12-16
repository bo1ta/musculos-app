//
//  UserExperienceEntryEntity+CoreDataProperties.swift
//
//
//  Created by Solomon Alexandru on 15.12.2024.
//
//

import Foundation
import CoreData
import Models

@objc(UserExperienceEntryEntity)
public class UserExperienceEntryEntity: NSManagedObject {
  @NSManaged public var modelID: UUID
  @NSManaged public var xpGained: Int
  @NSManaged public var userExperience: UserExperienceEntity

  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserExperienceEntryEntity> {
    return NSFetchRequest<UserExperienceEntryEntity>(entityName: "UserExperienceEntryEntity")
  }
}

extension UserExperienceEntryEntity: ReadOnlyConvertible {
  public func toReadOnly() -> UserExperienceEntry {
    return UserExperienceEntry(
      id: modelID,
      userExperience: userExperience.toReadOnly(),
      xpGained: xpGained
    )
  }
}

extension UserExperienceEntryEntity: EntitySyncable {
  public func populateEntityFrom(_ model: UserExperienceEntry, using storage: any StorageType) {
    self.modelID = model.id
    self.xpGained = model.xpGained

    let userExperienceEntity = storage.findOrInsert(of: UserExperienceEntity.self, using: PredicateProvider.userExperienceByID(model.userExperience.id))
    userExperienceEntity.populateEntityFrom(model.userExperience, using: storage)
  }

  public func updateEntityFrom(_ model: UserExperienceEntry, using storage: any StorageType) {
    self.xpGained = model.xpGained
  }
}

//
//  ProgressEntryEntity.swift
//
//
//  Created by Solomon Alexandru on 27.09.2024.
//
//

import CoreData
import Foundation
import Models

@objc(ProgressEntryEntity)
public class ProgressEntryEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntryEntity> {
    return NSFetchRequest<ProgressEntryEntity>(entityName: "ProgressEntryEntity")
  }

  @NSManaged public var value: NSNumber
  @NSManaged public var dateAdded: Date
  @NSManaged public var goal: GoalEntity?
  @NSManaged public var progressID: UUID
}

extension ProgressEntryEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ProgressEntry? {
    guard let goal else {
      return nil
    }
    return ProgressEntry(
      progressID: progressID,
      dateAdded: dateAdded,
      value: value.doubleValue,
      goal: goal.toReadOnly()
    )
  }
}

extension ProgressEntryEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ProgressEntry, using _: StorageType) {
    value = model.value as NSNumber
    dateAdded = model.dateAdded
    progressID = model.progressID
  }

  public func updateEntityFrom(_ model: ProgressEntry, using _: StorageType) {
    value = model.value as NSNumber
    dateAdded = model.dateAdded
  }
}

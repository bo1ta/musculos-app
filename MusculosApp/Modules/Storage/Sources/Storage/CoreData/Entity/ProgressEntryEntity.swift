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

// MARK: - ProgressEntryEntity

@objc(ProgressEntryEntity)
public class ProgressEntryEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ProgressEntryEntity> {
    NSFetchRequest<ProgressEntryEntity>(entityName: "ProgressEntryEntity")
  }

  @NSManaged public var value: NSNumber
  @NSManaged public var dateAdded: Date
  @NSManaged public var goal: GoalEntity?
  @NSManaged public var progressID: UUID
}

// MARK: ReadOnlyConvertible

extension ProgressEntryEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ProgressEntry? {
    guard let goal else {
      return nil
    }
    return ProgressEntry(
      id: progressID,
      dateAdded: dateAdded,
      value: value.doubleValue,
      goal: goal.toReadOnly())
  }
}

// MARK: EntitySyncable

extension ProgressEntryEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ProgressEntry, using _: StorageType) {
    value = model.value as NSNumber
    dateAdded = model.dateAdded
    progressID = model.id
  }

  public func updateEntityFrom(_ model: ProgressEntry, using _: StorageType) {
    value = model.value as NSNumber
    dateAdded = model.dateAdded
  }
}

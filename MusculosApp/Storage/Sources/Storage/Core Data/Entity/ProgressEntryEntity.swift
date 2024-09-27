//
//  ProgressEntryEntity+CoreDataClass.swift
//  
//
//  Created by Solomon Alexandru on 27.09.2024.
//
//

import Foundation
import CoreData
import Models

@objc(ProgressEntryEntity)
public class ProgressEntryEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ProgressEntryEntity> {
    return NSFetchRequest<ProgressEntryEntity>(entityName: "ProgressEntryEntity")
  }

  @NSManaged public var value: NSNumber
  @NSManaged public var dateAdded: Date
  @NSManaged public var goal: GoalEntity?
}

extension ProgressEntryEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ProgressEntry? {
    guard let goal else {
      return nil
    }
    return ProgressEntry(
      dateAdded: dateAdded,
      value: value.doubleValue,
      goal: goal.toReadOnly()
    )
  }
}

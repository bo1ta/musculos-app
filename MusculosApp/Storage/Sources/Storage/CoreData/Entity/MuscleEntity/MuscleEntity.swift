//
//  MuscleEntity.swift
//
//
//  Created by Solomon Alexandru on 12.12.2024.
//
//

import CoreData
import Foundation

@objc(MuscleEntity)
public class MuscleEntity: NSManagedObject {
  @NSManaged public var muscleID: NSNumber
  @NSManaged public var name: String

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MuscleEntity> {
    return NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
  }
}

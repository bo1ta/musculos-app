//
//  MuscleEntity+CoreDataProperties.swift
//  
//
//  Created by Solomon Alexandru on 12.12.2024.
//
//

import Foundation
import CoreData


@objc(MuscleEntity)
public class MuscleEntity: NSManagedObject {
  @NSManaged public var muscleID: NSNumber
  @NSManaged public var name: String

  @nonobjc public class func fetchRequest() -> NSFetchRequest<MuscleEntity> {
    return NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
  }
}

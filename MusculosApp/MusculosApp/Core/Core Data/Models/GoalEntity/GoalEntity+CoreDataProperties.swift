//
//  GoalEntity+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//
//

import Foundation
import CoreData


extension GoalEntity {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
    return NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
  }
  
  @NSManaged public var name: String?
  @NSManaged public var endTime: Date?
  @NSManaged public var category: String?
  @NSManaged public var targetValue: Float
}

extension GoalEntity : Identifiable {
}


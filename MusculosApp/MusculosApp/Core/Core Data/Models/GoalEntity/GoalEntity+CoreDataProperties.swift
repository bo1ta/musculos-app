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
  @NSManaged public var endDate: Date?
  @NSManaged public var category: String?
  @NSManaged public var targetValue: String?
  @NSManaged public var isCompleted: Bool
}

extension GoalEntity : Identifiable {
  
}

// MARK: - Read Only Convertible

extension GoalEntity: ReadOnlyConvertible {
  func toReadOnly() -> Goal {
    var goalCategory: Goal.GoalCategory = .general
    if let category = self.category, let categoryType = Goal.GoalCategory(rawValue: category)  {
      goalCategory = categoryType
    }
    
    return Goal(
      name: self.name ?? "",
      category: goalCategory,
      targetValue: self.targetValue ?? "",
      endDate: self.endDate,
      isCompleted: self.isCompleted
    )
  }
}

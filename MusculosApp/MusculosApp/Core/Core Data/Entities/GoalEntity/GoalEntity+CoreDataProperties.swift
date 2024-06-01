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
  @NSManaged public var frequency: String?
}

extension GoalEntity : Identifiable {}

// MARK: - Read Only Convertible

extension GoalEntity: ReadOnlyConvertible {
  typealias GoalCategory = Goal.Category
  typealias GoalFrequency = Goal.Frequency
  
  func toReadOnly() -> Goal {
    var goalCategory: GoalCategory = .general
    if let category, let categoryType = GoalCategory(rawValue: category)  {
      goalCategory = categoryType
    }
    
    var goalFrequency: GoalFrequency = .daily
    if let frequency, let frequencyType = GoalFrequency(rawValue: frequency) {
      goalFrequency = frequencyType
    }
    
    return Goal(
      name: self.name ?? "",
      category: goalCategory,
      frequency: goalFrequency,
      targetValue: self.targetValue ?? "",
      endDate: self.endDate,
      isCompleted: self.isCompleted
    )
  }
}

//
//  GoalEntity.swift
//
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import CoreData
import Models

@objc(GoalEntity)
public class GoalEntity: NSManagedObject {
  @NSManaged public var goalID: UUID
  @NSManaged public var name: String?
  @NSManaged public var endDate: Date?
  @NSManaged public var category: String?
  @NSManaged public var targetValue: NSNumber?
  @NSManaged public var isCompleted: Bool
  @NSManaged public var frequency: String?
  @NSManaged public var targetMuscles: [String]?
  @NSManaged public var dateAdded: Date?
  @NSManaged public var progressHistory: Set<ProgressEntryEntity>
  @NSManaged public var user: UserProfileEntity

  @nonobjc public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
    return NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
  }

  @objc(addProgressHistoryObject:)
  @NSManaged public func addToProgressHistory(_ value: ProgressEntryEntity)

  @objc(removeProgressHistoryObject:)
  @NSManaged public func removeFromProgressHistory(_ value: PrimaryMuscleEntity)
}

extension GoalEntity : Identifiable {}

// MARK: - Read Only Convertible

extension GoalEntity: ReadOnlyConvertible {
  typealias GoalCategory = Goal.Category
  typealias GoalFrequency = Goal.Frequency

  public func toReadOnly() -> Goal {
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
      progressHistory: [],
      targetValue: self.targetValue?.intValue ?? 0,
      endDate: self.endDate,
      isCompleted: self.isCompleted,
      dateAdded: self.dateAdded ?? Date(),
      user: self.user.toReadOnly()
    )
  }
}

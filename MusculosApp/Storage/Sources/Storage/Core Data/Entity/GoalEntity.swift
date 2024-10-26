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
  @NSManaged public var name: String
  @NSManaged public var endDate: Date?
  @NSManaged public var category: String?
  @NSManaged public var targetValue: NSNumber?
  @NSManaged public var isCompleted: Bool
  @NSManaged public var frequency: String?
  @NSManaged public var targetMuscles: [String]?
  @NSManaged public var dateAdded: Date
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
      name: name,
      category: goalCategory,
      frequency: goalFrequency,
      progressHistory: [],
      targetValue: targetValue?.intValue ?? 0,
      endDate: endDate,
      isCompleted: isCompleted,
      dateAdded: dateAdded,
      user: user.toReadOnly()
    )
  }
}

// MARK: - Entity Syncable

extension GoalEntity: EntitySyncable {
  public func populateEntityFrom(_ model: Goal, using storage: StorageType) {
    self.category = model.category.rawValue
    self.dateAdded = model.dateAdded
    self.endDate = model.endDate
    self.frequency = model.frequency.rawValue
    self.isCompleted = model.isCompleted
    self.name = model.name
    self.targetValue = NSNumber(integerLiteral: model.targetValue)

    for progress in model.progressHistory {
      let progressEntity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
      progressEntity.populateEntityFrom(progress, using: storage)
      addToProgressHistory(progressEntity)
    }
  }

  public func updateEntityFrom(_ model: Goal, using storage: StorageType) {
    if model.targetValue > self.targetValue?.intValue ?? 0 {
      self.targetValue = NSNumber(integerLiteral: model.targetValue)
    }

    if self.endDate == nil {
      self.endDate = model.endDate
    }

    if model.progressHistory.count > self.progressHistory.count {
      let mappedProgress = self.progressHistory.map { $0.toReadOnly()?.progressID }
      let history = model.progressHistory.filter { entry in
        !mappedProgress.contains(entry.progressID)
      }
      for entry in history {
        let progressEntity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
        addToProgressHistory(progressEntity)
      }
    }
  }
}

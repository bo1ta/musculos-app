//
//  GoalEntity.swift
//
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import CoreData
import Models
import Principle

// MARK: - GoalEntity

@objc(GoalEntity)
public class GoalEntity: NSManagedObject {
  @NSManaged public var goalID: UUID
  @NSManaged public var userID: UUID
  @NSManaged public var name: String
  @NSManaged public var endDate: Date?
  @NSManaged public var category: String?
  @NSManaged public var targetValue: NSNumber?
  @NSManaged public var isCompleted: Bool
  @NSManaged public var frequency: String?
  @NSManaged public var targetMuscles: [String]?
  @NSManaged public var dateAdded: Date
  @NSManaged public var progressHistory: Set<ProgressEntryEntity>
  @NSManaged public var updatedAt: Date?

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<GoalEntity> {
    NSFetchRequest<GoalEntity>(entityName: "GoalEntity")
  }

  @objc(addProgressHistoryObject:)
  @NSManaged
  public func addToProgressHistory(_ value: ProgressEntryEntity)

  @objc(removeProgressHistoryObject:)
  @NSManaged
  public func removeFromProgressHistory(_ value: PrimaryMuscleEntity)
}

// MARK: Identifiable

extension GoalEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension GoalEntity: ReadOnlyConvertible {
  typealias GoalCategory = Goal.Category
  typealias GoalFrequency = Goal.Frequency

  public func toReadOnly() -> Goal {
    var goalFrequency = GoalFrequency.daily
    if let frequency, let frequencyType = GoalFrequency(rawValue: frequency) {
      goalFrequency = frequencyType
    }

    return Goal(
      name: name,
      category: category,
      frequency: goalFrequency,
      progressEntries: [],
      targetValue: targetValue?.intValue ?? 0,
      endDate: endDate,
      isCompleted: isCompleted,
      dateAdded: dateAdded)
  }
}

// MARK: EntitySyncable

extension GoalEntity: EntitySyncable {
  public func populateEntityFrom(_ model: Goal, using storage: StorageType) {
    goalID = model.id
    category = model.category
    dateAdded = model.dateAdded
    endDate = model.endDate
    frequency = model.frequency.rawValue
    isCompleted = model.isCompleted
    name = model.name
    targetValue = model.targetValue as NSNumber
    updatedAt = model.updatedAt
    userID = model.userID ?? UUID()

    guard let progressEntries = model.progressEntries else {
      return
    }

    for progress in progressEntries {
      let progressEntity = storage.insertNewObject(ofType: ProgressEntryEntity.self)
      progressEntity.populateEntityFrom(progress, using: storage)
      addToProgressHistory(progressEntity)
    }
  }

  public func updateEntityFrom(_ model: Goal, using storage: StorageType) {
    if model.targetValue > targetValue?.intValue ?? 0 {
      targetValue = model.targetValue as NSNumber
    }

    if endDate == nil {
      endDate = model.endDate
    }

    guard let progressEntries = model.progressEntries else {
      return
    }

    if progressEntries.count > progressHistory.count {
      let mappedProgress = progressHistory.map { $0.toReadOnly()?.progressID }

      let history = progressEntries.filter { entry in
        !mappedProgress.contains(entry.progressID)
      }

      for entry in history {
        let predicate: NSPredicate = \ProgressEntryEntity.progressID == entry.progressID
        let progressEntity = storage.findOrInsert(of: ProgressEntryEntity.self, using: predicate)
        progressEntity.populateEntityFrom(entry, using: storage)

        addToProgressHistory(progressEntity)
      }
    }

    updatedAt = model.updatedAt
  }
}

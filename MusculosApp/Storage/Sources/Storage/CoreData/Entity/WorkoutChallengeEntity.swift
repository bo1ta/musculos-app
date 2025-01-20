//
//  WorkoutChallengeEntity.swift
//
//
//  Created by Solomon Alexandru on 20.01.2025.
//
//

import CoreData
import Foundation
import Models

// MARK: - WorkoutChallengeEntity

@objc(WorkoutChallengeEntity)
public class WorkoutChallengeEntity: NSManagedObject {

  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<WorkoutChallengeEntity> {
    NSFetchRequest<WorkoutChallengeEntity>(entityName: "WorkoutChallengeEntity")
  }

  @NSManaged public var uniqueID: UUID
  @NSManaged public var title: String
  @NSManaged public var challengeDescription: String
  @NSManaged public var level: String
  @NSManaged public var durationInDays: NSNumber
  @NSManaged public var currentDay: NSNumber
  @NSManaged public var startDate: Date?
  @NSManaged public var completionDate: Date?
  @NSManaged public var dailyWorkouts: Set<DailyWorkoutEntity>
}

// MARK: Generated accessors for dailyWorkouts
extension WorkoutChallengeEntity {
  @objc(addDailyWorkoutsObject:)
  @NSManaged
  public func addToDailyWorkouts(_ value: DailyWorkoutEntity)

  @objc(removeDailyWorkoutsObject:)
  @NSManaged
  public func removeFromDailyWorkouts(_ value: DailyWorkoutEntity)

  @objc(addDailyWorkouts:)
  @NSManaged
  public func addToDailyWorkouts(_ values: NSSet)

  @objc(removeDailyWorkouts:)
  @NSManaged
  public func removeFromDailyWorkouts(_ values: NSSet)
}

// MARK: ReadOnlyConvertible

extension WorkoutChallengeEntity: ReadOnlyConvertible {
  public func toReadOnly() -> WorkoutChallenge {
    let dailyWorkouts = dailyWorkouts.map { $0.toReadOnly() }
    return WorkoutChallenge(
      id: uniqueID,
      title: title,
      description: challengeDescription,
      level: ChallengeLevel(rawValue: level) ?? .beginner,
      durationInDays: durationInDays.intValue,
      dailyWorkouts: dailyWorkouts,
      currentDay: currentDay.intValue,
      startDate: startDate,
      completionDate: completionDate)
  }
}

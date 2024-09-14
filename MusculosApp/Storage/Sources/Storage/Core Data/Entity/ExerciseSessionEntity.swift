//
//  ExerciseSessionEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//
//

import Foundation
import CoreData
import Models

@objc(ExerciseSessionEntity)
public class ExerciseSessionEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseSessionEntity> {
    return NSFetchRequest<ExerciseSessionEntity>(entityName: "ExerciseSessionEntity")
  }

  @NSManaged public var date: Date
  @NSManaged public var sessionId: UUID
  @NSManaged public var user: UserProfileEntity
  @NSManaged public var exercise: ExerciseEntity
}

extension ExerciseSessionEntity: Identifiable {}

extension ExerciseSessionEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ExerciseSession {
    let user = self.user.toReadOnly()
    let exercise = self.exercise.toReadOnly()

    return ExerciseSession(
      date: self.date,
      sessionId: self.sessionId,
      user: user!,
      exercise: exercise
    )
  }
}

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

  @NSManaged public var dateAdded: Date
  @NSManaged public var duration: NSNumber
  @NSManaged public var sessionId: UUID
  @NSManaged public var user: UserProfileEntity
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var weight: NSNumber
}

extension ExerciseSessionEntity: Identifiable {}

extension ExerciseSessionEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ExerciseSession {
    let user = self.user.toReadOnly()
    let exercise = self.exercise.toReadOnly()

    return ExerciseSession(
      dateAdded: self.dateAdded,
      sessionId: self.sessionId,
      user: user,
      exercise: exercise
    )
  }
}

extension ExerciseSessionEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ExerciseSession, using storage: StorageType) {
    guard let user = storage.firstObject(
      of: UserProfileEntity.self,
      matching: PredicateProvider.userProfileById(model.user.userId)
    )
    else { return }

    self.user = user
    self.dateAdded = model.dateAdded
    self.duration = NSNumber(floatLiteral: model.duration)
    self.sessionId = model.sessionId
    self.exercise = ExerciseEntity.findOrCreate(from: model.exercise, using: storage)
    self.weight = NSNumber(floatLiteral: model.weight ?? 0)
  }

  public func updateEntityFrom(_ model: ExerciseSession, using storage: StorageType) {
    self.dateAdded = model.dateAdded
    self.duration = NSNumber(floatLiteral: model.duration)
  }
}

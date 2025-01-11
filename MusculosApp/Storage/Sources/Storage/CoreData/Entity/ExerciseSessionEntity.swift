//
//  ExerciseSessionEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.06.2024.
//
//

import CoreData
import Foundation
import Models
import Principle

// MARK: - ExerciseSessionEntity

@objc(ExerciseSessionEntity)
public class ExerciseSessionEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ExerciseSessionEntity> {
    NSFetchRequest<ExerciseSessionEntity>(entityName: "ExerciseSessionEntity")
  }

  @NSManaged public var dateAdded: Date
  @NSManaged public var duration: NSNumber
  @NSManaged public var sessionId: UUID
  @NSManaged public var user: UserProfileEntity
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var weight: NSNumber
}

// MARK: Identifiable

extension ExerciseSessionEntity: Identifiable { }

// MARK: ReadOnlyConvertible

extension ExerciseSessionEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ExerciseSession {
    let user = user.toReadOnly()
    let exercise = exercise.toReadOnly()

    return ExerciseSession(
      dateAdded: dateAdded,
      sessionId: sessionId,
      user: user,
      exercise: exercise)
  }
}

// MARK: EntitySyncable

extension ExerciseSessionEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ExerciseSession, using storage: StorageType) {
    guard
      let user = storage.firstObject(of: UserProfileEntity.self, matching: \UserProfileEntity.userId == model.user.userId)
    else {
      return
    }

    self.user = user
    dateAdded = model.dateAdded
    duration = model.duration as NSNumber
    sessionId = model.sessionId
    exercise = ExerciseEntity.findOrCreate(from: model.exercise, using: storage)
    weight = NSNumber(floatLiteral: model.weight ?? 0) // swiftlint:disable:this compiler_protocol_init
  }

  public func updateEntityFrom(_ model: ExerciseSession, using _: StorageType) {
    dateAdded = model.dateAdded
    duration = model.duration as NSNumber
  }
}

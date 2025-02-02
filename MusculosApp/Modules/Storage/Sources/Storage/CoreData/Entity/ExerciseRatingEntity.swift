//
//  ExerciseRatingEntity.swift
//
//
//  Created by Solomon Alexandru on 23.11.2024.
//
//

import CoreData
import Foundation
import Models
import Principle

// MARK: - ExerciseRatingEntity

@objc(ExerciseRatingEntity)
public class ExerciseRatingEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ExerciseRatingEntity> {
    NSFetchRequest<ExerciseRatingEntity>(entityName: "ExerciseRatingEntity")
  }

  @NSManaged public var uniqueID: UUID
  @NSManaged public var rating: NSNumber
  @NSManaged public var isPublic: Bool
  @NSManaged public var comment: String?
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var user: UserProfileEntity
}

// MARK: ReadOnlyConvertible

extension ExerciseRatingEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ExerciseRating {
    ExerciseRating(
      id: uniqueID,
      exerciseID: exercise.uniqueID,
      userID: user.uniqueID,
      isPublic: isPublic,
      rating: rating.doubleValue)
  }
}

// MARK: EntitySyncable

extension ExerciseRatingEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ExerciseRating, using storage: any StorageType) {
    guard
      let exerciseEntity = storage.firstObject(
        of: ExerciseEntity.self,
        matching: \ExerciseEntity.uniqueID == model.exerciseID),
      let userProfileEntity = storage.firstObject(
        of: UserProfileEntity.self,
        matching: \UserProfileEntity.uniqueID == model.userID)
    else {
      return
    }

    uniqueID = model.id
    rating = model.rating as NSNumber
    isPublic = model.isPublic ?? true
    comment = model.comment

    exercise = exerciseEntity
    exerciseEntity.ratings.insert(self)

    user = userProfileEntity
    userProfileEntity.ratings.insert(self)
  }

  public func updateEntityFrom(_ model: ExerciseRating, using _: any StorageType) {
    comment = model.comment
    rating = model.rating as NSNumber
  }
}

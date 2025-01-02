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

// MARK: - ExerciseRatingEntity

@objc(ExerciseRatingEntity)
public class ExerciseRatingEntity: NSManagedObject {
  @nonobjc
  public class func fetchRequest() -> NSFetchRequest<ExerciseRatingEntity> {
    NSFetchRequest<ExerciseRatingEntity>(entityName: "ExerciseRatingEntity")
  }

  @NSManaged public var ratingID: UUID
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
      ratingID: ratingID,
      exerciseID: exercise.exerciseId,
      userID: user.userId,
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
        matching: PredicateProvider.exerciseById(model.exerciseID)),
      let userProfileEntity = storage.firstObject(
        of: UserProfileEntity.self,
        matching: PredicateProvider.userProfileById(model.userID))
    else {
      return
    }

    ratingID = model.ratingID
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

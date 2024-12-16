//
//  ExerciseRatingEntity+CoreDataClass.swift
//  
//
//  Created by Solomon Alexandru on 23.11.2024.
//
//

import Foundation
import CoreData
import Models

@objc(ExerciseRatingEntity)
public class ExerciseRatingEntity: NSManagedObject {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<ExerciseRatingEntity> {
      return NSFetchRequest<ExerciseRatingEntity>(entityName: "ExerciseRatingEntity")
  }

  @NSManaged public var ratingID: UUID
  @NSManaged public var rating: NSNumber
  @NSManaged public var isPublic: Bool
  @NSManaged public var comment: String?
  @NSManaged public var exercise: ExerciseEntity
  @NSManaged public var user: UserProfileEntity
}

// MARK: - ReadOnlyConvertible

extension ExerciseRatingEntity: ReadOnlyConvertible {
  public func toReadOnly() -> ExerciseRating {
    return ExerciseRating(
      ratingID: ratingID,
      exerciseID: exercise.exerciseId,
      userID: user.userId,
      isPublic: isPublic,
      rating: rating.doubleValue
    )
  }
}

// MARK: - EntitySyncable

extension ExerciseRatingEntity: EntitySyncable {
  public func populateEntityFrom(_ model: ExerciseRating, using storage: any StorageType) {
    guard
      let exerciseEntity = storage.firstObject(of: ExerciseEntity.self, matching: PredicateProvider.exerciseById(model.exerciseID)),
      let userProfileEntity = storage.firstObject(of: UserProfileEntity.self, matching: PredicateProvider.userProfileById(model.userID))
    else { return }

    self.exercise = exerciseEntity
    self.user = userProfileEntity
    self.ratingID = model.ratingID
    self.rating = NSNumber(floatLiteral: model.rating)
    self.isPublic = model.isPublic ?? true
    self.comment = model.comment
  }

  public func updateEntityFrom(_ model: ExerciseRating, using storage: any StorageType) {
    self.comment = model.comment
    self.rating = NSNumber(floatLiteral: model.rating)
  }
}

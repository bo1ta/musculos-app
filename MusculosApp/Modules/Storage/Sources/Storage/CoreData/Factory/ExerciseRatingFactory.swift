//
//  ExerciseRatingFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Foundation
import Models

public final class ExerciseRatingFactory: BaseFactory, @unchecked Sendable {
  public var ratingID: UUID?
  public var exerciseID: UUID?
  public var userID: UUID?
  public var isPublic: Bool?
  public var rating: Double?
  public var comment: String?
  public var isPersistent = true

  public func create() -> ExerciseRating {
    let exerciseRating = ExerciseRating(
      id: ratingID ?? UUID(),
      exerciseID: exerciseID ?? ExerciseFactory.createExercise().id,
      userID: userID ?? UserProfileFactory.createUser().id,
      isPublic: isPublic ?? false,
      rating: rating ?? 4.0,
      comment: comment ?? "awesome")
    syncObject(exerciseRating, of: ExerciseRatingEntity.self)
    return exerciseRating
  }

  public static func createExerciseRating(isPersistent: Bool = true) -> ExerciseRating {
    let factory = ExerciseRatingFactory()
    factory.isPersistent = isPersistent
    return factory.create()
  }
}

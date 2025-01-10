//
//  RatingRepositoryStub.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation
import Models
import Utility

public struct RatingRepositoryStub: RatingRepositoryProtocol {
  var expectedRatings: [ExerciseRating]
  var expectedUserRating: Double?

  public init(expectedRatings: [ExerciseRating] = [], expectedUserRating: Double? = nil) {
    self.expectedRatings = expectedRatings
    self.expectedUserRating = expectedUserRating
  }

  public func getExerciseRatingsForCurrentUser() async throws -> [Models.ExerciseRating] {
    expectedRatings
  }

  public func getUserRatingForExercise(_: UUID) async throws -> Double {
    if let expectedUserRating {
      return expectedUserRating
    }
    throw MusculosError.unexpectedNil
  }

  public func getRatingsForExercise(_: UUID) async throws -> [ExerciseRating] {
    expectedRatings
  }

  public func addRating(rating _: Double, for _: UUID) async throws { }
}

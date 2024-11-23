//
//  ExerciseRating.swift
//  Models
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Foundation
import Utility

public struct ExerciseRating: Codable {
  public var ratingID: UUID
  public var exerciseID: UUID
  public var userID: UUID
  public var isPublic: Bool
  public var rating: Double
  public var comment: String?

  public init(ratingID: UUID, exerciseID: UUID, userID: UUID, isPublic: Bool, rating: Double, comment: String? = nil) {
    self.ratingID = ratingID
    self.exerciseID = exerciseID
    self.userID = userID
    self.isPublic = isPublic
    self.rating = rating
    self.comment = comment
  }
}

extension ExerciseRating: DecodableModel {}

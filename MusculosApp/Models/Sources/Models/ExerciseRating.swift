//
//  ExerciseRating.swift
//  Models
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Foundation
import Utility

// MARK: - ExerciseRating

public struct ExerciseRating: Codable, Sendable {
  public var id: UUID
  public var exerciseID: UUID
  public var userID: UUID
  public var isPublic: Bool?
  public var rating: Double
  public var comment: String?

  public init(
    id: UUID = UUID(),
    exerciseID: UUID,
    userID: UUID,
    isPublic: Bool = true,
    rating: Double,
    comment: String? = nil)
  {
    self.id = id
    self.exerciseID = exerciseID
    self.userID = userID
    self.isPublic = isPublic
    self.rating = rating
    self.comment = comment
  }

  enum CodingKeys: String, CodingKey {
    case id = "ratingID"
    case exerciseID
    case userID
    case isPublic
    case rating
    case comment
  }
}

// MARK: DecodableModel

extension ExerciseRating: DecodableModel { }

// MARK: IdentifiableEntity

extension ExerciseRating: IdentifiableEntity { }

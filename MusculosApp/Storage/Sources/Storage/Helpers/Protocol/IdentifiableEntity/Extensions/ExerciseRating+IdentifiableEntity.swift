//
//  ExerciseRating+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Models
import Foundation

extension ExerciseRating: IdentifiableEntity {
  public static let identifierKey: String = "ratingID"

  public var identifierValue: UUID {
    self.ratingID
  }
}

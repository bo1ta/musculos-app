//
//  ExerciseRating+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Foundation
import Models

extension ExerciseRating: IdentifiableEntity {
  public static let identifierKey: String = "ratingID"

  public var identifierValue: UUID {
    ratingID
  }
}

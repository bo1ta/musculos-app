//
//  WorkoutExercise+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Foundation
import Models

extension WorkoutExercise: IdentifiableEntity {
  public static let identifierKey: String = "modelID"

  public var identifierValue: UUID {
    id
  }
}

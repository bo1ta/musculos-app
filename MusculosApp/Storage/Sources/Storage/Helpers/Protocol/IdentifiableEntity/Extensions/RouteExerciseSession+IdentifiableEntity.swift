//
//  RouteExerciseSession+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 17.01.2025.
//

import Foundation
import Models

extension RouteExerciseSession: IdentifiableEntity {
  public static let identifierKey = "uuid"

  public var identifierValue: UUID {
    uuid
  }
}

//
//  Workout+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Foundation
import Models

extension Workout: IdentifiableEntity {
  public static let identifierKey = "modelID"

  public var identifierValue: UUID {
    id
  }
}

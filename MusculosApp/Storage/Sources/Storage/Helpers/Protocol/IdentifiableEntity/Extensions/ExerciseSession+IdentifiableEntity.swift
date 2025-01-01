//
//  ExerciseSession+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 12.10.2024.
//

import Foundation
import Models

extension ExerciseSession: IdentifiableEntity {
  public static let identifierKey = "sessionId"

  public var identifierValue: UUID {
    sessionId
  }
}

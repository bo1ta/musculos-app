//
//  Exercise+IdentifiableEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation
import Models

extension Exercise: IdentifiableEntity {
  public static let identifierKey = "exerciseId"

  public var identifierValue: UUID {
    id
  }
}

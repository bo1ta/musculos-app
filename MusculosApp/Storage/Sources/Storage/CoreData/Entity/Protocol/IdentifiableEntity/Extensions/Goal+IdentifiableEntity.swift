//
//  Goal+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models

extension Goal: IdentifiableEntity {
  public static let identifierKey = "goalID"

  public var identifierValue: UUID {
    id
  }
}

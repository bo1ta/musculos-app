//
//  UserExperienceEntry+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import Foundation
import Models

extension UserExperienceEntry: IdentifiableEntity {
  public static let identifierKey = "modelID"

  public var identifierValue: UUID { id }
}

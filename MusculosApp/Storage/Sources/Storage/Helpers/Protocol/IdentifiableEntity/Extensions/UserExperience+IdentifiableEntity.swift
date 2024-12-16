//
//  UserExperience+IdentifiableEntity.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.12.2024.
//

import Foundation
import Models

extension UserExperience: IdentifiableEntity {
  public static let identifierKey: String = "modelID"

  public var identifierValue: UUID { id }
}

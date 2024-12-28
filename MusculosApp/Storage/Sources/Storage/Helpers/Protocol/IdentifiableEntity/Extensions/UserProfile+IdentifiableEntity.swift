//
//  UserProfile+IdentifiableEntity.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation
import Models

extension UserProfile: IdentifiableEntity {
  public static let identifierKey: String = "userId"

  public var identifierValue: UUID {
    userId
  }
}

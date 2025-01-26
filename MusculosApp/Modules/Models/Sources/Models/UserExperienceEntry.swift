//
//  UserExperienceEntry.swift
//  Models
//
//  Created by Solomon Alexandru on 15.12.2024.
//

import Foundation
import Utility

public struct UserExperienceEntry: Sendable, Codable, DecodableModel, IdentifiableEntity {
  public var id: UUID
  public var userExperience: UserExperience
  public var xpGained: Int

  public init(id: UUID, userExperience: UserExperience, xpGained: Int) {
    self.id = id
    self.userExperience = userExperience
    self.xpGained = xpGained
  }
}

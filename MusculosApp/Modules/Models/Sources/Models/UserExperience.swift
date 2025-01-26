//
//  UserExperience.swift
//  Models
//
//  Created by Solomon Alexandru on 15.12.2024.
//

import Foundation
import Utility

public struct UserExperience: Sendable, Codable, DecodableModel, IdentifiableEntity {
  public var id: UUID
  public var totalExperience: Int
  public var experienceEntries: [UserExperienceEntry]?

  public init(id: UUID, totalExperience: Int, experienceEntries: [UserExperienceEntry]? = nil) {
    self.id = id
    self.totalExperience = totalExperience
    self.experienceEntries = experienceEntries
  }
}

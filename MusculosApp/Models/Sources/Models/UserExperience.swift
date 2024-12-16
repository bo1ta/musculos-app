//
//  UserExperience.swift
//  Models
//
//  Created by Solomon Alexandru on 15.12.2024.
//

import Foundation
import Utility

public struct UserExperience: Sendable, Codable, DecodableModel {
  public var id: UUID
  public var userID: UUID
  public var totalExperience: Int
  public var experienceEntries: [UserExperienceEntry]

  public init(id: UUID, userID: UUID, totalExperience: Int, experienceEntries: [UserExperienceEntry]) {
    self.id = id
    self.userID = userID
    self.totalExperience = totalExperience
    self.experienceEntries = experienceEntries
  }
}

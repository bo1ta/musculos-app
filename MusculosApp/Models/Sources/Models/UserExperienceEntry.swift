//
//  UserExperienceEntry.swift
//  Models
//
//  Created by Solomon Alexandru on 15.12.2024.
//

import Foundation
import Utility

public struct UserExperienceEntry: Codable, DecodableModel {
  public var id: UUID
  public var userExperience: UserExperience
  public var xpGained: Int
  public var calculationDetails: String?

  public init(id: UUID, userExperience: UserExperience, xpGained: Int, calculationDetails: String? = nil) {
    self.id = id
    self.userExperience = userExperience
    self.xpGained = xpGained
    self.calculationDetails = calculationDetails
  }
}

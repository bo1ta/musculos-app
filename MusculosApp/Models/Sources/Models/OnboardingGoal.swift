//
//  OnboardingGoal.swift
//  Models
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Utility

public struct OnboardingGoal: DecodableModel, Sendable {
  public let id: UUID
  public let title: String
  public let description: String
  public let iconName: String

  public init(id: UUID, title: String, description: String, iconName: String) {
    self.id = id
    self.title = title
    self.description = description
    self.iconName = iconName
  }
}

extension OnboardingGoal: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(title)
    hasher.combine(description)
  }
}

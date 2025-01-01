//
//  OnboardingData.swift
//  Models
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation

public struct OnboardingData: Sendable {
  public let weight: Int?
  public let height: Int?
  public let level: String?
  public let goal: OnboardingGoal?

  public init(weight: Int?, height: Int?, level: String?, goal: OnboardingGoal?) {
    self.weight = weight
    self.height = height
    self.level = level
    self.goal = goal
  }
}

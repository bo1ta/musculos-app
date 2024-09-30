//
//  GoalFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import Utility

public struct GoalFactory {
  public struct Default {
    public static let name = "Lose weight"
    public static let category: Goal.Category = .loseWeight
    public static let frequency: Goal.Frequency = .weekly
    public static let targetValue = 20
    public static let endDate: Date = Date().dayAfter
    public static let dateAdded: Date = Date()
    public static let user = UserProfileFactory.createProfile()
  }

  public static func createGoal(
    name: String = Default.name,
    category: Goal.Category = Default.category,
    frequency: Goal.Frequency = Default.frequency,
    targetValue: Int = Default.targetValue,
    endDate: Date = Default.endDate,
    dateAdded: Date = Default.dateAdded,
    user: UserProfile = Default.user
  ) -> Goal {
    return Goal(
      name: name,
      category: category,
      frequency: frequency,
      targetValue: targetValue,
      endDate: endDate,
      dateAdded: dateAdded,
      user: user
    )
  }
}

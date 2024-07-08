//
//  GoalFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import Utility

public struct GoalFactory {
  public static func createGoal(name: String =  "Lose weight", category: Goal.Category = .loseWeight, frequency: Goal.Frequency = .weekly, targetValue: Int = 20, endDate: Date = Date().dayAfter, dateAdded: Date = Date()) -> Goal {
    return Goal(
      name: name,
      category: category,
      frequency: frequency,
      targetValue: targetValue,
      endDate: endDate,
      dateAdded: dateAdded
    )
  }
}

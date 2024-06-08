//
//  GoalFactory.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

struct GoalFactory {
  static func createGoal(name: String =  "Lose weight", category: Goal.Category = .loseWeight, frequency: Goal.Frequency = .weekly, targetValue: String = "20", endDate: Date = Date().dayAfter) -> Goal {
    return Goal(
      name: name,
      category: category,
      frequency: frequency,
      targetValue: targetValue,
      endDate: endDate
    )
  }
}

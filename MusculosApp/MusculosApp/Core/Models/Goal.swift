//
//  Goal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Foundation
import SwiftUI

struct Goal {
  enum GoalCategory: String, CaseIterable {
    case loseWeight, gainWeight, growMuscle, drinkWater, general
    
    var label: String {
      switch self {
      case .loseWeight: "Lose weight"
      case .gainWeight: "Gain mass"
      case .growMuscle: "Grow muscles"
      case .drinkWater: "Drink water"
      case .general: "General"
      }
    }
  }
  
  let name: String
  let category: GoalCategory
  let targetValue: String
  let endDate: Date?
  let isCompleted: Bool
  
  init(name: String, category: GoalCategory, targetValue: String, endDate: Date?, isCompleted: Bool = false) {
    self.name = name
    self.category = category
    self.targetValue = targetValue
    self.endDate = endDate
    self.isCompleted = isCompleted
  }
}

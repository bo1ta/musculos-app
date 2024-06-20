//
//  Goal.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Foundation
import SwiftUI

struct Goal {
  let name: String
  let category: Category
  let frequency: Frequency
  let currentValue: Int
  let targetValue: String
  let endDate: Date?
  let isCompleted: Bool
  
  init(name: String, category: Category, frequency: Frequency,  currentValue: Int = 0, targetValue: String, endDate: Date?, isCompleted: Bool = false) {
    self.name = name
    self.category = category
    self.frequency = frequency
    self.currentValue = currentValue
    self.targetValue = targetValue
    self.endDate = endDate
    self.isCompleted = isCompleted
  }
  
  init(onboardingGoal: OnboardingData.Goal) {
    self.name = onboardingGoal.title
    self.category = Category.initFromLabel(onboardingGoal.title) ?? .general
    self.frequency = .weekly
    self.currentValue = 0
    self.targetValue = ""
    self.endDate = DateHelper.getDateFromNextWeek()
    self.isCompleted = false
  }
}

// MARK: - Helper types

extension Goal {
  enum Category: String, CaseIterable {
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
    
    static func initFromLabel(_ label: String) -> Self? {
      return Self.allCases.first { $0.label == label }
    }
  }
  
  enum Frequency: String, CaseIterable {
    case daily
    case weekly
    case fixedDate
    
    var description: String {
      switch self {
      case .daily: "daily"
      case .weekly: "weekly"
      case .fixedDate: "fixed date"
      }
    }
  }
}

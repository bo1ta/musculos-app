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
  let targetValue: Int
  let endDate: Date?
  let isCompleted: Bool
  let dateAdded: Date
  
  var isExpired: Bool {
    if let endDate {
      return Date() > endDate
    }
    return false
  }
  
  var daysUntilExpires: Int? {
    guard let endDate else { return nil }
    
    let calendar = Calendar.current
    let currentDate = Date()
    let components = calendar.dateComponents([.day], from: currentDate, to: endDate)
    return components.day
  }
  
  var progressPercentage: Double {
    guard targetValue != 0 else {
      return 0
    }
    let progress = Double(currentValue) / Double(targetValue) * 100
    return min(max(progress, 0), 100)
  }
  
  var formattedProgressPercentage: String {
    return String(format: "%.0f%%", progressPercentage)
  }
  
  init(name: String, category: Category, frequency: Frequency,  currentValue: Int = 0, targetValue: Int, endDate: Date?, isCompleted: Bool = false, dateAdded: Date) {
    self.name = name
    self.category = category
    self.frequency = frequency
    self.currentValue = currentValue
    self.targetValue = targetValue
    self.endDate = endDate
    self.isCompleted = isCompleted
    self.dateAdded = dateAdded
  }
  
  init(onboardingGoal: OnboardingData.Goal) {
    self.name = onboardingGoal.title
    self.category = Category.initFromLabel(onboardingGoal.title) ?? .general
    self.frequency = .weekly
    self.currentValue = 0
    self.targetValue = 5
    self.endDate = DateHelper.getDateFromNextWeek()
    self.isCompleted = false
    self.dateAdded = Date()
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

//
//  WorkoutGoal.swift
//  Models
//
//  Created by Solomon Alexandru on 28.09.2024.
//

import Foundation
import SwiftUI

public enum WorkoutGoal: Int, CaseIterable, Sendable {
  case general = 0
  case growMuscles = 1
  case loseWeight = 2
  case increaseStrength = 3
  case improveEndurance = 4
  case flexibility = 5

  public var iconName: String {
    switch self {
    case .general: return "health-sneakers"
    case .growMuscles: return "health-biceps"
    case .loseWeight: return "health-counter"
    case .increaseStrength: return "health-dumbbell"
    case .improveEndurance: return "health-treadmill"
    case .flexibility: return "health-jump-rope"
    }
  }

  public var title: String {
    switch self {
    case .general: return "General"
    case .growMuscles: return "Grow muscles"
    case .loseWeight: return "Lose weight"
    case .increaseStrength: return "Increase strength"
    case .improveEndurance: return "Improve endurance"
    case .flexibility: return "Flexibility"
    }
  }

  public var color: Color {
    switch self {
    case .general: return .blue
    case .growMuscles: return .green
    case .loseWeight: return .red
    case .increaseStrength: return .yellow
    case .improveEndurance: return .purple
    case .flexibility: return .orange
    }
  }

  public var goalCategory: Goal.Category {
    switch self {
    case .general, .flexibility, .improveEndurance:
      return .general
    case .growMuscles, .increaseStrength:
      return .growMuscle
    case .loseWeight:
      return .loseWeight
    }
  }
}

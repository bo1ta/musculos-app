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
    case .general: "health-sneakers"
    case .growMuscles: "health-biceps"
    case .loseWeight: "health-counter"
    case .increaseStrength: "health-dumbbell"
    case .improveEndurance: "health-treadmill"
    case .flexibility: "health-jump-rope"
    }
  }

  public var title: String {
    switch self {
    case .general: "General"
    case .growMuscles: "Grow muscles"
    case .loseWeight: "Lose weight"
    case .increaseStrength: "Increase strength"
    case .improveEndurance: "Improve endurance"
    case .flexibility: "Flexibility"
    }
  }

  public var color: Color {
    switch self {
    case .general: .blue
    case .growMuscles: .green
    case .loseWeight: .red
    case .increaseStrength: .yellow
    case .improveEndurance: .purple
    case .flexibility: .orange
    }
  }

  public var goalCategory: Goal.Category {
    switch self {
    case .general, .flexibility, .improveEndurance:
      .general
    case .growMuscles, .increaseStrength:
      .growMuscle
    case .loseWeight:
      .loseWeight
    }
  }
}

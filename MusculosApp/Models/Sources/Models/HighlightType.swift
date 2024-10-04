//
//  HighlightType.swift
//  Models
//
//  Created by Solomon Alexandru on 04.10.2024.
//

import SwiftUI
import Utility

public enum ProfileHighlightType: CaseIterable, Hashable {
  case steps
  case sleep
  case waterIntake
  case workoutTracking

  public var systemImageName: String {
    switch self {
    case .steps: return "figure.run"
    case .sleep: return "sleep"
    case .waterIntake: return "drop.fill"
    case .workoutTracking: return "dumbbell.fill"
    }
  }

  public var color: Color {
    switch self {
    case .steps: return .yellow
    case .sleep: return AppColor.navyBlue
    case .waterIntake: return .orange.opacity(0.6)
    case .workoutTracking: return .red
    }
  }

  public var title: String {
    switch self {
    case .steps: "Steps"
    case .sleep: "Sleep"
    case .waterIntake: "Water intake"
    case .workoutTracking: "Workout tracking"
    }
  }
}

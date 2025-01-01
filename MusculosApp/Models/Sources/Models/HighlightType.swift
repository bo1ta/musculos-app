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
    case .steps: "figure.run"
    case .sleep: "sleep"
    case .waterIntake: "drop.fill"
    case .workoutTracking: "dumbbell.fill"
    }
  }

  public var color: Color {
    switch self {
    case .steps: .yellow
    case .sleep: AppColor.navyBlue
    case .waterIntake: .orange.opacity(0.6)
    case .workoutTracking: .red
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

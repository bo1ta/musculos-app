//
//  WorkoutDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.01.2025.
//

import Models
import Navigator
import SwiftUI

// MARK: - WorkoutDestinations

public enum WorkoutDestinations {
  case exerciseDetails(Exercise)
}

// MARK: NavigationDestination

extension WorkoutDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }
}

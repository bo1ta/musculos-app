//
//  CommonDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

// MARK: - CommonDestinations

enum CommonDestinations {
  case exerciseDetails(Exercise)
}

// MARK: NavigationDestination

extension CommonDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }
}

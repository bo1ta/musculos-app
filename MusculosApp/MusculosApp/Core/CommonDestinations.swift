//
//  CommonDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Navigator
import Models
import SwiftUI

enum CommonDestinations {
  case exerciseDetails(Exercise)
}

extension CommonDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }
}

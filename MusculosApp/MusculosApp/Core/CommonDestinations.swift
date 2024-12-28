//
//  CommonDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

enum CommonDestinations {
  case exerciseDetails(Exercise)
}

extension CommonDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case let .exerciseDetails(exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }
}

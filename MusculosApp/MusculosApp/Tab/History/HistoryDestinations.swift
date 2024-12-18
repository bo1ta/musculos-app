//
//  HistoryDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import SwiftUI
import Models
import Navigator

public enum HistoryDestinations {
  case exerciseDetails(Exercise)
}

extension HistoryDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }
}

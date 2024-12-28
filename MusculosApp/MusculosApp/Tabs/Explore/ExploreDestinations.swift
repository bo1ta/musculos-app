//
//  ExploreDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

public enum ExploreDestinations {
  case exerciseListByGoal(WorkoutGoal)
  case exerciseListByMuscleGroup(MuscleGroup)
  case exerciseFilters
}

extension ExploreDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case let .exerciseListByGoal(workoutGoal):
      ExerciseListView(filterType: .filteredByWorkoutGoal(workoutGoal))
    case let .exerciseListByMuscleGroup(muscleGroup):
      ExerciseListView(filterType: .filteredByMuscleGroup(muscleGroup))
    case .exerciseFilters:
      ExerciseFilterSheet(onFiltered: { _ in })
    }
  }

  public var method: NavigationMethod {
    switch self {
    case .exerciseListByGoal:
      .push
    case .exerciseListByMuscleGroup:
      .push
    case .exerciseFilters:
      .sheet
    }
  }
}

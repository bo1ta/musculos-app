//
//  ExploreDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

// MARK: - ExploreDestinations

public enum ExploreDestinations {
  case exerciseListByGoal(WorkoutGoal)
  case exerciseListByMuscleGroup(MuscleGroup)
  case exerciseFilters
}

// MARK: NavigationDestination

extension ExploreDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .exerciseListByGoal(let workoutGoal):
      ExerciseListView(filterType: .filteredByWorkoutGoal(workoutGoal))
    case .exerciseListByMuscleGroup(let muscleGroup):
      ExerciseListView(filterType: .filteredByMuscleGroup(muscleGroup))
    case .exerciseFilters:
      ExerciseFilterSheet()
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

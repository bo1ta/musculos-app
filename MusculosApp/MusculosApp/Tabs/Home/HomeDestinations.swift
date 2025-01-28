//
//  HomeDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import SwiftUI

// MARK: - HomeDestinations

public enum HomeDestinations {
  case addGoal
  case notifications
  case dailyWorkout(workoutChallenge: WorkoutChallenge, dailyWorkout: DailyWorkout)
  case exerciseDetails(Exercise)
}

// MARK: NavigationDestination

extension HomeDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .addGoal:
      AddGoalSheet(onBack: { })

    case .notifications:
      EmptyView()

    case .dailyWorkout(let workoutChallenge, let dailyWorkout):
      RootWorkoutScreen(workoutChallenge: workoutChallenge, dailyWorkout: dailyWorkout)
        .presentationDetents([.medium])

    case .exerciseDetails(let exercise):
      ExerciseDetailsScreen(exercise: exercise)
    }
  }

  public var method: NavigationMethod {
    switch self {
    case .notifications:
      .push
    case .addGoal:
      .sheet
    case .dailyWorkout:
      .sheet
    case .exerciseDetails:
      .sheet
    }
  }
}

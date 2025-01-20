//
//  HomeDestinations.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Models
import Navigator
import RouteKit
import SwiftUI

// MARK: - HomeDestinations

public enum HomeDestinations {
  case addGoal
  case notifications
  case liveRoute
  case dailyWorkout(workoutChallenge: WorkoutChallenge, dailyWorkout: DailyWorkout)
}

// MARK: NavigationDestination

extension HomeDestinations: NavigationDestination {
  public var view: some View {
    switch self {
    case .addGoal:
      AddGoalSheet(onBack: { })

    case .notifications:
      RoutePlannerScreen()

    case .liveRoute:
      RoutePlannerScreen()

    case .dailyWorkout(let workoutChallenge, let dailyWorkout):
      RootWorkoutScreen(workoutChallenge: workoutChallenge, dailyWorkout: dailyWorkout)
        .presentationDetents([.medium, .expandedExtra])
    }
  }

  public var method: NavigationMethod {
    switch self {
    case .notifications:
        .push
    case .liveRoute:
        .push
    case .addGoal:
        .sheet
    case .dailyWorkout:
        .sheet
    }
  }
}

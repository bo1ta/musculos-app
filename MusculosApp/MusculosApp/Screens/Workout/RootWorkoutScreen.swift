//
//  RootWorkoutScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.01.2025.
//

import Models
import Navigator
import SwiftUI

// MARK: - RootWorkoutScreen

struct RootWorkoutScreen: View {
  let workoutChallenge: WorkoutChallenge
  let dailyWorkout: DailyWorkout

  var body: some View {
    ManagedNavigationStack(scene: "workout") {
      DailyWorkoutScreen(workoutChallenge: workoutChallenge, dailyWorkout: dailyWorkout)
        .navigationCheckpoint(.workout)
        .navigationDestination(WorkoutDestinations.self)
    }
  }
}

extension NavigationCheckpoint {
  static let workout: NavigationCheckpoint = "workout"
}

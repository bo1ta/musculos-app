//
//  HomeScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import Components
import Models
import Navigator
import Storage
import SwiftUI
import Utility

struct HomeScreen: View {
  @Environment(\.navigator) private var navigator: Navigator

  @State private var viewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        UserHeader(
          profile: viewModel.currentUser,
          onNotificationsTap: navigateToLiveRoute)

        AchievementCard()
          .defaultShimmering(active: viewModel.isLoading)

        GoalsSection(goals: viewModel.goals, onAddGoal: showAddGoalSheet)

        if let exercises = viewModel.quickExercises {
          QuickWorkoutSection(exercises: exercises, onSelect: navigateToExerciseDetails(_:))
        }

        if let workoutChallenge = viewModel.workoutChallenge {
          ChallengesSection(workoutChallenge: workoutChallenge, onSelectDailyWorkout: showDailyWorkoutSheet(_:))
        }
      }
      .frame(alignment: .top)
      .padding(.bottom, 30)
      .padding([.horizontal, .bottom], 10)
    }
    .scrollIndicators(.hidden)
    .task {
      await viewModel.initialLoad()
    }
  }

  private func navigateToLiveRoute() {
    navigator.navigate(to: HomeDestinations.liveRoute)
  }

  private func navigateToExerciseDetails(_ exercise: Exercise) {
    navigator.navigate(to: CommonDestinations.exerciseDetails(exercise))
  }

  private func showDailyWorkoutSheet(_ workout: DailyWorkout) {
    guard let workoutChallenge = viewModel.workoutChallenge else {
      Logger.error(MusculosError.unexpectedNil, message: "Trying to navigate to daily workout sheet without a workout challenge")
      return
    }
    navigator.navigate(to: HomeDestinations.dailyWorkout(workoutChallenge: workoutChallenge, dailyWorkout: workout))
  }

  private func showAddGoalSheet() {
    navigator.navigate(to: HomeDestinations.addGoal)
  }
}

#Preview {
  HomeScreen()
}

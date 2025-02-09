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
        UserHeader(profile: viewModel.currentUser, onNotificationsTap: showNotificationsScreen)

        GoalsSection(goals: viewModel.goals, onAddGoal: showAddGoalSheet)
        QuickWorkoutSection(state: viewModel.quickExercises, onSelect: navigateToExerciseDetails(_:))
        ChallengesSection(state: viewModel.workoutChallenge, onSelectDailyWorkout: showDailyWorkoutSheet(_:))
      }
      .frame(alignment: .top)
      .padding(.bottom, 30)
      .padding([.horizontal, .bottom], 10)
    }
    .scrollIndicators(.hidden)
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.onDisappear)
  }

  private func showNotificationsScreen() { }

  private func navigateToExerciseDetails(_ exercise: Exercise) {
    navigator.navigate(to: CommonDestinations.exerciseDetails(exercise))
  }

  private func showDailyWorkoutSheet(_ workout: DailyWorkout) {
    guard let workoutChallenge = viewModel.workoutChallenge.resultOrNil() else {
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

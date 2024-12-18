//
//  HomeScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import SwiftUI
import Storage
import Models
import Components
import Utility
import Navigator

struct HomeScreen: View {
  @Environment(\.navigator) private var navigator: Navigator
  @Environment(\.userStore) private var userStore

  @State private var viewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        GreetingHeader(
          profile: userStore.currentUserProfile,
          onNotificationsTap: {
            navigator.navigate(to: HomeDestinations.notifications)
          }
        )

        AchievementCard()
          .defaultShimmering(active: viewModel.isLoading)

        GoalsSection(goals: viewModel.goals, onAddGoal: {
          navigator.navigate(to: HomeDestinations.addGoal)
        })

        if let exercises = viewModel.quickExercises {
          QuickWorkoutSection(exercises: exercises)
        }

        ChallengesSection()

        WhiteBackgroundCard()
        Spacer()
      }
      .padding(.horizontal, 10)
    }
    .task {
      await viewModel.fetchData()
    }
    .onDisappear(perform: viewModel.onDisappear)
    .scrollIndicators(.hidden)
  }
}

#Preview {
  HomeScreen()
}

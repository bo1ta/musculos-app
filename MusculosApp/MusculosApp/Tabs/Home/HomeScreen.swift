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
  @Environment(\.userStore) private var userStore

  @State private var viewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        UserHeader(
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
      }
      .frame(alignment: .top)
      .padding(.bottom, 30)
      .padding([.horizontal, .bottom], 10)
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

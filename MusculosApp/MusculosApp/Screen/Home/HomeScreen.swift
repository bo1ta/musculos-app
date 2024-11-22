//
//  HomeScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import SwiftUI
import Models
import Components
import Utility

struct HomeScreen: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(alignment: .leading, spacing: 15) {
        GreetingHeader(
          profile: userStore.currentUserProfile,
          onNotificationsTap: {
            navigationRouter.push(.notifications)
          }
        )

        AchievementCard()
          .defaultShimmering(active: viewModel.isLoading)


        GoalsSection(goals: viewModel.goals, onAddGoal: {
          navigationRouter.present(.addGoalSheet)
        })

        if let exercise = viewModel.quickExercise {
          Group {
            Text("Quick workout")
              .font(AppFont.spartan(.semiBold, size: 23))
            QuickActionCard(title: exercise.name, subtitle: exercise.category, onTap: {
              navigationRouter.push(.exerciseDetails(exercise))
            })
          }
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

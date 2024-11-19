//
//  HomeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import SwiftUI
import Models
import Components
import Utility

struct HomeView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel = HomeViewModel()

  let exercise = ExerciseFactory.createExercise()

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
          
        })

        Group {
          Text("Quick workout")
            .font(AppFont.spartan(.semiBold, size: 23))
          QuickActionCard(title: exercise.name, subtitle: exercise.category, onTap: {})
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
    .scrollIndicators(.hidden)
  }
}

#Preview {
  HomeView()
}

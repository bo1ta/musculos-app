//
//  HomeView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.09.2024.
//

import SwiftUI
import Models
import Components

struct HomeView: View {
  @Environment(\.userStore) private var userStore
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var viewModel = HomeViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 15) {
        GreetingHeader(
          profile: viewModel.currentUser,
          onSearchTap: {
            navigationRouter.push(.search)
          },
          onNotificationsTap: {
            navigationRouter.push(.notifications)
          }
        )

        AchievementCard()
          .defaultShimmering(active: viewModel.isLoading)
        FeaturedWorkoutsSection(onSeeMore: {}, onWorkoutGoalSelected: { workoutGoal in
          navigationRouter.push(.exerciseListByGoal(workoutGoal))
        })
        RecommendationSection(
          exercises: viewModel.recommendedExercises,
          onSelectExercise: { exercise in
            navigationRouter.push(.exerciseDetails(exercise))
          },
          onSeeMore: {
            navigationRouter.push(.search)
          }
        )
        .fixedSize(horizontal: false, vertical: true)
        ChallengesSection(onSeeMore: {})
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

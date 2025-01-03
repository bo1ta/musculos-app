//
//  ExploreScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Components
import Models
import Navigator
import Storage
import SwiftUI
import Utility

struct ExploreScreen: View {
  @Environment(\.navigator) private var navigator: Navigator
  @State private var viewModel = ExploreViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        ExploreSearchSection(
          onFiltersTap: { navigator.navigate(to: ExploreDestinations.exerciseFilters) },
          onSearchQuery: { viewModel.searchByMuscleQuery($0) })
        FeaturedWorkoutsSection(onWorkoutGoalSelected: { navigator.navigate(to: ExploreDestinations.exerciseListByGoal($0)) })
        MusclesSection(onSelectedMuscle: { navigator.navigate(to: ExploreDestinations.exerciseListByMuscleGroup($0)) })

        if viewModel.showRecomendationsByGoals {
          RecommendationSection(
            exercises: viewModel.recommendedExercisesByGoals,
            onSelectExercise: navigateToExerciseDetails(_:),
            onSeeMore: { })
            .fixedSize(horizontal: false, vertical: true)
        }

        if viewModel.showRecommendationsByPastSessions {
          ExerciseSectionView(
            title: "Recommendations from past sessions",
            exercises: viewModel.recommendedExercisesByGoals,
            onExerciseTap: navigateToExerciseDetails(_:))
        }

        if viewModel.showFavoriteExercises {
          ExerciseSectionView(
            title: "My favorites",
            exercises: viewModel.favoriteExercises,
            onExerciseTap: navigateToExerciseDetails(_:))
        }

        ExerciseSectionView(
          title: "Featured exercises",
          exercises: viewModel.featuredExercises,
          onExerciseTap: navigateToExerciseDetails(_:))
      }
      .padding()
      .padding(.bottom, 30)
      .scrollIndicators(.hidden)
    }
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
  }

  private func navigateToExerciseDetails(_ exercise: Exercise) {
    navigator.navigate(to: CommonDestinations.exerciseDetails(exercise))
  }
}

#Preview {
  ExploreScreen()
}

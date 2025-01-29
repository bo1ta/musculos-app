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

        if let goal = viewModel.displayGoal, !viewModel.recommendedExercisesByGoals.isEmpty {
          ExerciseSectionView(
            title: "Recommendations for your \(goal.name) goal",
            exercises: viewModel.recommendedExercisesByGoals,
            onExerciseTap: navigateToExerciseDetails(_:),
            onSeeMore: {
              navigateToExerciseList(viewModel.recommendedExercisesByPastSessions)
            })
        }

        if !viewModel.recommendedExercisesByPastSessions.isEmpty {
          ExerciseSectionView(
            title: "Recommendations from past sessions",
            exercises: viewModel.recommendedExercisesByPastSessions,
            onExerciseTap: navigateToExerciseDetails(_:),
            onSeeMore: {
              navigateToExerciseList(viewModel.recommendedExercisesByPastSessions)
            })
        }

        ExerciseSectionView(
          title: "Featured exercises",
          exercises: viewModel.featuredExercises,
          onExerciseTap: navigateToExerciseDetails(_:),
          onSeeMore: {
            navigateToExerciseList(viewModel.featuredExercises)
          })
      }
      .padding()
      .padding(.bottom, 30)
      .scrollIndicators(.hidden)
    }
    .task {
      await viewModel.initialLoad()
    }
    .navigationCheckpoint(.explore) { (result: [Exercise]) in
      viewModel.setFilteredExercises(result)
    }
    .onDisappear(perform: viewModel.cleanUp)
  }

  private func navigateToExerciseDetails(_ exercise: Exercise) {
    navigator.navigate(to: CommonDestinations.exerciseDetails(exercise))
  }

  private func navigateToExerciseList(_ exercises: [Exercise]) {
    navigator.navigate(to: ExploreDestinations.exerciseList(exercises))
  }
}

#Preview {
  ExploreScreen()
}

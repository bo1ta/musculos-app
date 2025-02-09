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
        ExploreSearchSection(onFiltersTap: navigateToFilters, onSearchQuery: viewModel.searchByMuscleQuery)
        FeaturedWorkoutsSection(onWorkoutGoalSelected: navigateToExerciseListByGoal)
        MusclesSection(onSelectedMuscle: navigateToExerciseListByMuscleGroup)

        ExerciseSectionView(
          title: "Recommendations for your goals",
          state: viewModel.recommendedExercisesByGoals,
          onExerciseTap: navigateToExerciseDetails(_:),
          onSeeMore: {
            navigateToExerciseList(viewModel.recommendedExercisesByGoals.resultsOrEmpty())
          })

        ExerciseSectionView(
          title: "Recommendations from past sessions",
          state: viewModel.recommendedExercisesByPastSessions,
          onExerciseTap: navigateToExerciseDetails(_:),
          onSeeMore: {
            navigateToExerciseList(viewModel.recommendedExercisesByPastSessions.resultsOrEmpty())
          })

        ExerciseSectionView(
          title: "Featured exercises",
          state: viewModel.featuredExercises,
          onExerciseTap: navigateToExerciseDetails(_:),
          onSeeMore: {
            navigateToExerciseList(viewModel.featuredExercises.resultsOrEmpty())
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

  // MARK: Navigation methods

  private func navigateToFilters() {
    navigator.navigate(to: ExploreDestinations.exerciseFilters)
  }

  private func navigateToExerciseListByGoal(_ goal: WorkoutGoal) {
    navigator.navigate(to: ExploreDestinations.exerciseListByGoal(goal))
  }

  private func navigateToExerciseListByMuscleGroup(_ muscleGroup: MuscleGroup) {
    navigator.navigate(to: ExploreDestinations.exerciseListByMuscleGroup(muscleGroup))
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

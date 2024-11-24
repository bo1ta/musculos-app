//
//  ExploreScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI
import Components
import Storage
import Models
import Utility

struct ExploreScreen: View {
  @Environment(\.navigationRouter) private var navigationRouter
  @State private var viewModel = ExploreViewModel()

  var body: some View {
    ScrollView {
      VStack(spacing: 20) {
        ExploreSearchSection(
          onFiltersTap: {
            viewModel.showFilterView.toggle()
          },
          onSearchQuery: { searchQuery in
            viewModel.searchByMuscleQuery(searchQuery)
          }
        )

        FeaturedWorkoutsSection(onWorkoutGoalSelected: { workoutGoal in
          navigationRouter.push(.exerciseListByGoal(workoutGoal))
        })

        MusclesSection(onSelectedMuscle: { muscleGroup in
          navigationRouter.push(.exerciseListByMuscleGroup(muscleGroup))
        })

        if !viewModel.recommendedExercisesByGoals.isEmpty {
          RecommendationSection(
            exercises: viewModel.recommendedExercisesByGoals,
            onSelectExercise: { exercise in
              navigationRouter.push(.exerciseDetails(exercise))
            },
            onSeeMore: {
              navigationRouter.push(.search)
            }
          )
          .fixedSize(horizontal: false, vertical: true)
        }

        if !viewModel.recommendedExercisesByPastSessions.isEmpty {
          ExerciseSectionView(title: "Recommendations from past sessions", exercises: viewModel.recommendedExercisesByGoals, onExerciseTap: { exercise in
            navigationRouter.push(.exerciseDetails(exercise))
          })
        }

        if !viewModel.favoriteExercises.isEmpty {
          ExerciseSectionView(title: "My favorites", exercises: viewModel.favoriteExercises, onExerciseTap: { exercise in
            navigationRouter.push(.exerciseDetails(exercise))
          })
        }

        ExerciseSectionView(title: "Featured exercises", exercises: viewModel.featuredExercises, onExerciseTap: { exercise in
          navigationRouter.push(.exerciseDetails(exercise))
        })

        WhiteBackgroundCard()
      }
      .padding()
      .scrollIndicators(.hidden)
    }
    .popover(isPresented: $viewModel.showFilterView) {
      ExerciseFilterSheet(onFiltered: { filteredExercises in
        viewModel.setFeaturedExercises(filteredExercises)
      })
    }
    .task {
      await viewModel.initialLoad()
    }
    .onDisappear(perform: viewModel.cleanUp)
  }
}

#Preview {
  ExploreScreen()
}

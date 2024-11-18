//
//  ExploreExerciseView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import SwiftUI
import Components
import Storage
import Models
import Utility

struct ExploreExerciseView: View {
  @Environment(\.navigationRouter) private var navigationRouter
  @State private var viewModel = ExploreExerciseViewModel()

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

        MusclesSection(onSelectedMuscle: { muscle in
          navigationRouter.push(.exerciseListByMuscle(muscle))
        })
        ExerciseSectionView(title: "Featured exercises", exercises: viewModel.featuredExercises, onExerciseTap: { exercise in
          navigationRouter.push(.exerciseDetails(exercise))
        })

        if !viewModel.favoriteExercises.isEmpty {
          ExerciseSectionView(title: "My favorites", exercises: viewModel.favoriteExercises, onExerciseTap: { exercise in
            navigationRouter.push(.exerciseDetails(exercise))
          })
        }

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

        WhiteBackgroundCard()
      }
      .padding()
      .scrollIndicators(.hidden)
    }
    .popover(isPresented: $viewModel.showFilterView) {
      ExerciseFilterView(onFiltered: { filteredExercises in
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
  ExploreExerciseView()
}

//
//  ExerciseListView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.09.2024.
//

import SwiftUI
import Models
import Components
import NetworkClient
import Factory
import Utility
import DataRepository

struct ExerciseListView: View {
  @Environment(\.navigationRouter) private var navigationRouter
  @State private var state: LoadingViewState<[Exercise]> = .empty
  @Injected(\DataRepositoryContainer.exerciseRepository) private var repository: ExerciseRepository

  enum FilterType {
    case filteredByWorkoutGoal(WorkoutGoal)
    case filteredByMuscle(MuscleType)
  }

  let filterType: FilterType

  init(filterType: FilterType) {
    self.filterType = filterType
  }

  var body: some View {
    VStack {
      ScrollView {
        switch state {
        case .loading:
          loadingSkeleton
        case .loaded(let exercises):
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              navigationRouter.push(.exerciseDetails(exercise))
            }, label: {
              ExerciseSecondaryCard(exercise: exercise)
            })
            .buttonStyle(.plain)
          }
        case .empty:
          EmptyView()
        case .error(let errorMessage):
          Text(errorMessage)
        }

      }
    }
    .task {
      do {
        try await initialLoad()
      } catch {
        state = .error("Could not load data")
      }
    }
  }

  private var loadingSkeleton: some View {
    VStack {
      ForEach(0..<10) { _ in
        ExerciseSecondaryCard(exercise: ExerciseFactory.createExercise())
          .redacted(reason: .placeholder)
      }
      .defaultShimmering()
    }
  }

  @MainActor
  private func initialLoad() async throws {
    state = .loading

    switch filterType {
    case .filteredByWorkoutGoal(let workoutGoal):
      let exercises = try await repository.getExercisesByWorkoutGoal(workoutGoal)
      state = .loaded(exercises)
    case .filteredByMuscle(let muscleType):
      let exercises = try await repository.searchByMuscleQuery(muscleType.rawValue)
      state = .loaded(exercises)
    }
  }
}

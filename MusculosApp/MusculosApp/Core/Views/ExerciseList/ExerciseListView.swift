//
//  ExerciseListView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.09.2024.
//

import Components
import DataRepository
import Factory
import Models
import Navigator
import Storage
import SwiftUI
import Utility

struct ExerciseListView: View {
  @Environment(\.navigator) private var navigator
  @Injected(\DataRepositoryContainer.exerciseRepository) private var repository: ExerciseRepository

  @State private var state: LoadingViewState<[Exercise]> = .empty
  @State private var searchQuery: String = ""
  @State private var results: [Exercise] = []

  let filterType: FilterType

  init(filterType: FilterType) {
    self.filterType = filterType
  }

  var body: some View {
    VStack {
      switch state {
      case .loading:
        loadingSkeleton
      case let .loaded(exercises):
        List(exercises, id: \.id) { exercise in
          VStack {
            Button(action: {
              navigator.push(CommonDestinations.exerciseDetails(exercise))
            }, label: {
              ExerciseListRow(exercise: exercise)
            })
            .buttonStyle(.plain)
          }
        }
        .navigationTitle(filterType.navigationBarTitle)
        .searchable(
          text: $searchQuery,
          placement: .automatic,
          prompt: ""
        )
        .textInputAutocapitalization(.never)
        .listStyle(.plain)
      case .empty:
        EmptyView()
      case let .error(errorMessage):
        Text(errorMessage)
      }
    }
    .task {
      guard state == .empty else {
        return
      }
      do {
        try await initialLoad()
      } catch {
        state = .error("Could not load data")
      }
    }
    .onChange(of: searchQuery) { _, newValue in
      guard case var .loaded(exercises) = state, !newValue.isEmpty else {
        state = .loaded(results)
        return
      }

      exercises = exercises.filter { $0.name.localizedCaseInsensitiveContains(newValue) }
      state = .loaded(exercises)
    }
    .tabBarHidden()
  }

  private var loadingSkeleton: some View {
    List(0 ..< 10) { _ in
      ExerciseListRow(exercise: ExerciseFactory.createExercise())
        .redacted(reason: .placeholder)
    }
    .defaultShimmering()
  }

  @MainActor
  private func initialLoad() async throws {
    state = .loading

    switch filterType {
    case let .filteredByWorkoutGoal(workoutGoal):
      let exercises = try await repository.getExercisesByWorkoutGoal(workoutGoal)
      results = exercises
      state = .loaded(results)
    case let .filteredByMuscleGroup(muscleGroup):
      let exercises = try await repository.getByMuscleGroup(muscleGroup)
      results = exercises
      state = .loaded(results)
    }
  }
}

extension ExerciseListView {
  enum FilterType {
    case filteredByWorkoutGoal(WorkoutGoal)
    case filteredByMuscleGroup(MuscleGroup)

    var navigationBarTitle: String {
      switch self {
      case .filteredByWorkoutGoal: "Filtered by workout goal"
      case .filteredByMuscleGroup: "Filtered by muscle group"
      }
    }
  }
}

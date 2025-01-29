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

// MARK: - ExerciseListView

struct ExerciseListView: View {
  @Environment(\.navigator) private var navigator
  @Injected(\DataRepositoryContainer.exerciseRepository) private var repository: ExerciseRepositoryProtocol

  @State private var state = LoadingViewState<[Exercise]>.empty
  @State private var searchQuery = ""
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

      case .loaded(let exercises):
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
          prompt: "")
        .textInputAutocapitalization(.never)
        .listStyle(.plain)

      case .empty:
        EmptyView()

      case .error(let errorMessage):
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
      guard case .loaded(var exercises) = state, !newValue.isEmpty else {
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
    case .filteredByWorkoutGoal(let workoutGoal):
      let exercises = try await repository.getExercisesByWorkoutGoal(workoutGoal)
      results = exercises
      state = .loaded(results)

    case .filteredByMuscleGroup(let muscleGroup):
      let exercises = try await repository.getByMuscleGroup(muscleGroup)
      results = exercises
      state = .loaded(results)

    case .all(let exercises):
      results = exercises
      state = .loaded(results)
    }
  }
}

// MARK: ExerciseListView.FilterType

extension ExerciseListView {
  enum FilterType {
    case filteredByWorkoutGoal(WorkoutGoal)
    case filteredByMuscleGroup(MuscleGroup)
    case all([Exercise])

    var navigationBarTitle: String {
      switch self {
      case .filteredByWorkoutGoal: "Filtered by workout goal"
      case .filteredByMuscleGroup: "Filtered by muscle group"
      case .all: "All exercises"
      }
    }
  }
}

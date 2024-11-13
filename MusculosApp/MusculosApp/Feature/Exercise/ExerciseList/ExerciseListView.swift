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

struct ExerciseListView: View {
  enum FilterType {
    case filteredByWorkoutGoal(WorkoutGoal)
    case filteredByMuscle(MuscleType)
  }

  let filterType: FilterType

  @Environment(\.navigationRouter) private var navigationRouter

  @State private var state: LoadingViewState<[Exercise]> = .empty

  @Injected(\NetworkContainer.exerciseService) private var exerciseService: ExerciseServiceProtocol

  init(filterType: FilterType) {
    self.filterType = filterType
  }

  var body: some View {
    VStack {
      ScrollView {
        switch state {
        case .loading:
          LoadingDotsView(dotsColor: .green)
        case .loaded(let exercises):
          ForEach(exercises, id: \.hashValue) { exercise in
            Button(action: {
              navigationRouter.push(.exerciseDetails(exercise))
            }, label: {
              ExerciseCard(exercise: exercise)
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

  @MainActor
  private func initialLoad() async throws {
    state = .loading

    switch filterType {
    case .filteredByWorkoutGoal(let workoutGoal):
      let exercises = try await exerciseService.getByWorkoutGoal(workoutGoal)
      state = .loaded(exercises)
    case .filteredByMuscle(let muscleType):
      let exercises = try await exerciseService.searchByMuscleQuery(muscleType.rawValue)
      state = .loaded(exercises)
    }
  }

  @MainActor
  func fetchExercises(for workoutGoal: WorkoutGoal) async {
    state = .loading
    do {
      let exercises = try await exerciseService.getByWorkoutGoal(workoutGoal)
      state = .loaded(exercises)
    } catch {
      state = .error(error.localizedDescription)
      MusculosLogger.logError(error, message: "Could not fetch exercises for exercise list", category: .networking)
    }
  }
}

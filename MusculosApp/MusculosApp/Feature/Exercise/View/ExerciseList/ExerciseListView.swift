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
  @Environment(\.navigationRouter) private var navigationRouter

  @State private var state: LoadingViewState<[Exercise]> = .empty

  @Injected(\NetworkContainer.exerciseService) private var exerciseService: ExerciseServiceProtocol

  var workoutGoal: WorkoutGoal

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
      await fetchExercises(for: workoutGoal)
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

#Preview {
  ExerciseListView(workoutGoal: .flexibility)
}

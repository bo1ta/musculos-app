//
//  WorkoutFlowView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import Models
import SwiftUI

struct WorkoutFlowView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: WorkoutFlowViewModel

  let workout: Workout
  let onComplete: () -> Void

  init(workout: Workout, onComplete: @escaping () -> Void) {
    viewModel = WorkoutFlowViewModel(workout: workout)
    self.workout = workout
    self.onComplete = onComplete
  }

  var body: some View {
    switch viewModel.step {
    case .intro:
      WorkoutIntroView(workout: workout, onStartTapped: viewModel.handleNextStep)

    case .session:
      if let exercise = viewModel.currentExercise {
        ExerciseDetailsScreen(exercise: exercise)
      }

    case .completion:
      EmptyView()
    }
  }
}

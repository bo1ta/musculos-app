//
//  WorkoutFlowView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import SwiftUI
import Models

struct WorkoutFlowView: View {
  @Environment(\.dismiss) private var dismiss
  @State private var viewModel: WorkoutFlowViewModel
  
  let workout: Workout
  let onComplete: () -> Void
  
  init(workout: Workout, onComplete: @escaping () -> Void) {
    self.viewModel = WorkoutFlowViewModel(workout: workout)
    self.workout = workout
    self.onComplete = onComplete
  }
  
  var body: some View {
    switch viewModel.step {
    case .intro:
      WorkoutIntroView(workout: workout, onStartTapped: viewModel.handleNextStep)
    case .session:
      if let exercise = viewModel.currentExercise {
        ExerciseDetailsScreen(exercise: exercise, onComplete: viewModel.handleNextExercise)
      }
    case .completion:
      EmptyView()
    }
  }
}

#Preview {
  WorkoutFlowView(workout: WorkoutFactory.create(), onComplete: {})
}

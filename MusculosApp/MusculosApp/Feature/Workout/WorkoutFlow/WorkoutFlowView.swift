//
//  WorkoutFlowView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import SwiftUI

struct WorkoutFlowView: View {
  @Environment(\.dismiss) private var dismiss
  @StateObject private var viewModel: WorkoutFlowViewModel
  
  let workout: Workout
  let onComplete: () -> Void
  
  init(workout: Workout, onComplete: @escaping () -> Void) {
    self._viewModel = StateObject(wrappedValue: WorkoutFlowViewModel(workout: workout))
    self.workout = workout
    self.onComplete = onComplete
  }
  
  var body: some View {
    switch viewModel.step {
    case .intro:
      WorkoutIntroView(workout: workout, onStartTapped: viewModel.handleNextStep)
    case .session:
      if let exercise = viewModel.currentExercise {
        ExerciseDetailsView(exercise: exercise, onComplete: viewModel.handleNextExercise)
      }
    case .completion:
      CongratulationView(exerciseName: workout.name, onGetReward: {
        
        dismiss()
      })
    }
  }
}

#Preview {
  WorkoutFlowView(workout: WorkoutFactory.create(), onComplete: {})
    .environmentObject(AppManager())
}

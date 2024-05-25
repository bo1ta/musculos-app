//
//  WorkoutFlowViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
import SwiftUI

final class WorkoutFlowViewModel: ObservableObject {
  enum Step {
    case intro
    case session
    case completion
  }
  
  @State private(set) var currentStep: Step = .intro
  @State private(set) var currentExerciseIndex = 0
  
  let workout: Workout
  
  init(workout: Workout) {
    self.workout = workout
  }
  
  var currentExercise: Exercise? {
    return workout.workoutExercises[safe: currentExerciseIndex]?.exercise
  }
  
  func handleNextExercise() {
    if currentExerciseIndex == workout.workoutExercises.count - 1 {
      currentStep = .completion
    } else {
      currentExerciseIndex += 1
    }
  }
  
  func handleNextStep() {
    withAnimation {
      switch currentStep {
      case .intro:
        currentStep = .session
        break
      case .session:
        currentStep = .completion
        break
      case .completion:
        break
      }
    }
  }
}

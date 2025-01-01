//
//  WorkoutFlowViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.05.2024.
//

import Foundation
import Models
import SwiftUI

@Observable
final class WorkoutFlowViewModel {
  enum Step {
    case intro
    case session
    case completion
  }

  private(set) var step = Step.intro
  private(set) var currentExerciseIndex = 0

  let workout: Workout

  init(workout: Workout) {
    self.workout = workout
  }

  var currentExercise: Exercise? {
    workout.workoutExercises[safe: currentExerciseIndex]?.exercise
  }

  func handleNextExercise() {
    if currentExerciseIndex == workout.workoutExercises.count - 1 {
      handleNextStep()
    } else {
      currentExerciseIndex += 1
    }
  }

  func handleNextStep() {
    withAnimation {
      switch step {
      case .intro:
        step = .session
      case .session:
        step = .completion
      case .completion:
        break
      }
    }
  }
}

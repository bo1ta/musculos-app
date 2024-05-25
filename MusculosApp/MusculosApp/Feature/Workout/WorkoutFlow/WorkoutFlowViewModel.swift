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
  
  @Published private(set) var step: Step = .intro
  @Published private(set) var currentExerciseIndex = 0
  
  let workout: Workout
  
  init(workout: Workout) {
    self.workout = workout
  }
  
  var currentExercise: Exercise? {
    return workout.workoutExercises[safe: currentExerciseIndex]?.exercise
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
        break
      case .session:
        step = .completion
        break
      case .completion:
        break
      }
    }
  }
}

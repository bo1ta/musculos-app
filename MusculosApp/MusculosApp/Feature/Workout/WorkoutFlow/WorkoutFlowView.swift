//
//  WorkoutFlowView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.05.2024.
//

import SwiftUI

struct WorkoutFlowView: View {
  enum Step {
    case intro
    case session
    case completion
  }
  
  @State private var currentStep: Step = .intro
  
  let workout: Workout
  let onComplete: () -> Void
  
    var body: some View {
      switch currentStep {
      case .intro:
        WorkoutIntroView(workout: workout, onStartTapped: handleNextStep)
      case .session:
        EmptyView()
      case .completion:
        EmptyView()
      }
    }
  
  private func handleNextStep() {
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

#Preview {
  WorkoutFlowView(workout: WorkoutFactory.create(), onComplete: {})
    .environmentObject(AppManager())
}

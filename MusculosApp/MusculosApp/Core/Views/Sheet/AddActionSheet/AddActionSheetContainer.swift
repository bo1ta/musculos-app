//
//  AddActionSheetContainer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import Components
import SwiftUI

struct AddActionSheetContainer: View {
  private enum Step {
    case createItem, createWorkout, createExercise, createGoal
  }

  @State private var currentStep = Step.createItem
  @Namespace private var animationNamespace

  var body: some View {
    VStack {
      switch currentStep {
      case .createItem:
        AddActionSheet(onItemTapped: handleTap(for:))
          .presentationDetents([.height(200)])
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .top).combined(with: .opacity))

      case .createWorkout:
        AddWorkoutSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.95)))

      case .createExercise:
        AddExerciseSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.95)))

      case .createGoal:
        AddGoalSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.95)))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: currentStep)
  }

  @MainActor
  private func handleTap(for itemType: AddActionSheet.ItemType) {
    withAnimation {
      switch itemType {
      case .exercise:
        currentStep = .createExercise
      case .goal:
        currentStep = .createGoal
      case .workout:
        currentStep = .createWorkout
      }
    }
  }

  @MainActor
  private func handleBack() {
    withAnimation {
      currentStep = .createItem
    }
  }
}

#Preview {
  AddActionSheetContainer()
}

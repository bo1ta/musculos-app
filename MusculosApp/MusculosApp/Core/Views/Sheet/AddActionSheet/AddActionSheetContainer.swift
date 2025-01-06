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
  @State private var presentationDetentState: PresentationDetent = .fraction(0.3)
  @Namespace private var animationNamespace

  var body: some View {
    VStack {
      switch currentStep {
      case .createItem:
        AddActionSheet(onItemTapped: handleTap(for:))
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)

      case .createWorkout:
        AddWorkoutSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.5)))

      case .createExercise:
        AddExerciseSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.5)))

      case .createGoal:
        AddGoalSheet(onBack: handleBack)
          .matchedGeometryEffect(id: "sheet", in: animationNamespace)
          .transition(.move(edge: .bottom).combined(with: .scale(scale: 0.5)))
      }
    }
    .onChange(of: currentStep, { _, newValue in
      if newValue == .createItem {
        presentationDetentState = .fraction(0.3)
      } else {
        presentationDetentState = .large
      }
    })
    .presentationDetents([.fraction(0.3), .large], selection: $presentationDetentState)
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

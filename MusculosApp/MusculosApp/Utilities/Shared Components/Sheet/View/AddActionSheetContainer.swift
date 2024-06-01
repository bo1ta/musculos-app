//
//  AddActionSheetContainer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct AddActionSheetContainer: View {
  private enum Step {
    case createItem, createWorkout, createExercise, createGoal
  }
  
  @State private var currentStep: Step = .createItem
  
  var body: some View {
    VStack {
      switch currentStep {
      case .createItem:
        AddActionSheet(onItemTapped: handleTap(for:))
          .presentationDetents([.height(300)])
          .transition(.asymmetric(insertion: .push(from: .top), removal: .push(from: .bottom)))
      case .createWorkout:
        AddWorkoutSheet(onBack: handleBack)
          .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .push(from: .top)))
      case .createExercise:
        AddExerciseSheet(onBack: handleBack)
          .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .push(from: .top)))
      case .createGoal:
        AddGoalSheet(onBack: handleBack)
          .transition(.asymmetric(insertion: .move(edge: .bottom), removal: .push(from: .top)))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: currentStep)
  }
  
  @MainActor
  private func handleTap(for itemType: AddActionSheet.ItemType) {
    switch itemType {
    case .exercise:
      currentStep = .createExercise
    case .goal:
      currentStep = .createGoal
    case .workout:
      currentStep = .createWorkout
    }
  }
  
  @MainActor
  private func handleBack() {
    currentStep = .createItem
  }
}

#Preview {
  AddActionSheetContainer()
    .environmentObject(AppManager())
}

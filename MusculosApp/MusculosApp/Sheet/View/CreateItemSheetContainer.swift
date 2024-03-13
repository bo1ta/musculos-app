//
//  CreateItemSheetContainer.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 13.03.2024.
//

import SwiftUI

struct CreateItemSheetContainer: View {
  private enum Step {
    case createItem, createWorkout, createExercise, createGoal, createChallenge
  }
  
  @State private var currentStep: Step = .createItem
  
  var body: some View {
    VStack {
      switch currentStep {
      case .createItem:
        CreateItemSheet(onItemTapped: handleTap(for:))
          .presentationDetents([.height(300)])
          .transition(.asymmetric(insertion: .move(edge: .top), removal: .push(from: .bottom)))
      case .createWorkout:
        CreateWorkoutSheet(onBack: handleBack)
          .presentationDetents([.height(400)])
          .transition(.asymmetric(insertion: .push(from: .bottom), removal: .move(edge: .bottom)))
      case .createExercise:
        EmptyView()
      case .createGoal:
        EmptyView()
      case .createChallenge:
        EmptyView()
      }
    }
    .animation(.easeInOut(duration: 0.25), value: currentStep)
  }
  
  @MainActor
  private func handleTap(for itemType: CreateItemSheet.ItemType) {
    switch itemType {
    case .challenge:
      currentStep = .createChallenge
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
  CreateItemSheetContainer()
}

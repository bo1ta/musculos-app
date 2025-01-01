//
//  OnboardingWizard.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Components
import SwiftUI

struct OnboardingWizard: View {
  @Bindable var viewModel: OnboardingViewModel

  var body: some View {
    VStack {
      switch viewModel.wizardStep {
      case .heightAndWeight:
        SelectSizeView(
          selectedWeight: $viewModel.selectedWeight,
          selectedHeight: $viewModel.selectedHeight,
          onContinue: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))

      case .level:
        SelectLevelView(
          selectedLevel: $viewModel.selectedLevel,
          onContinue: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))

      case .goal:
        SelectGoalView(
          onboardingGoals: viewModel.onboardingGoals,
          selectedGoal: $viewModel.selectedGoal,
          onContinue: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))

      case .permissions:
        PermissionsView(onDone: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .push(from: .top)))
      }
    }
    .animation(.smooth(duration: 0.2), value: viewModel.wizardStep)
    .dismissingGesture(direction: .left, action: { viewModel.handleBack() })
  }
}

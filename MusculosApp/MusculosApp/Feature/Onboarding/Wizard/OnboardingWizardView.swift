//
//  OnboardingWizardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import HealthKitUI
import Utility
import Components

struct OnboardingWizardView: View {
  @Environment(\.userStore) private var userStore: UserStore
  @State private var viewModel = OnboardingWizardViewModel()
  @State private var toast: Toast? = nil

  var body: some View {
    VStack {
      backButton

      currentWizardStep

      Spacer()
    }
    .onReceive(viewModel.eventPublisher) { event in
      handleEvent(event)
    }
    .modifier(KeyboardDismissableViewModifier())
    .padding(.horizontal, 10)
    .toastView(toast: $toast)
    .task {
      await viewModel.initialLoad()
    }
  }

  private func handleEvent(_ event: OnboardingWizardViewModel.Event) {
    switch event {
    case .didFinishOnboarding(let onboardingData):
      userStore.handlePostOnboarding(onboardingData)
    case .didFinishWithError(_):
      toast = Toast(style: .error, message: "Could not save data...")
    case .didFailLoadingOnboardingData:
      toast = Toast(style: .error, message: "Could not load data...")
    }
  }
}

// MARK: - Private views

extension OnboardingWizardView {
  private var currentWizardStep: some View {
    Group {
      switch viewModel.wizardStep {
      case .heightAndWeight:
        SelectSizeView(
          selectedWeight: $viewModel.selectedWeight,
          selectedHeight: $viewModel.selectedHeight,
          onContinue: viewModel.handleNextStep
        )
        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .level:
        SelectLevelView(
          selectedLevel: $viewModel.selectedLevel,
          onContinue: viewModel.handleNextStep
        )
        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .goal:
        SelectGoalView(
          onboardingGoals: viewModel.onboardingGoals,
          selectedGoal: $viewModel.selectedGoal,
          onContinue: viewModel.handleNextStep
        )
        .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .permissions:
        PermissionsView(onDone: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .push(from: .top)))
      }
    }
    .animation(.smooth(duration: 0.2), value: viewModel.wizardStep)
    .dismissingGesture(
      direction: .left,
      action: viewModel.handleBack
    )
  }

  private var backButton: some View {
    VStack {
      HStack {
        if viewModel.wizardStep != .heightAndWeight {
          Button(action: viewModel.handleBack, label: {
            Image(systemName: "arrow.backward")
              .foregroundStyle(.black)
          })
        }
        Spacer()
      }
      .padding(.horizontal, 20)
    }
  }
}

#Preview {
  OnboardingWizardView()
}

//
//  OnboardingScreen.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import Components
import HealthKitUI
import SwiftUI
import Utility

// MARK: - OnboardingScreen

struct OnboardingScreen: View {
  @Environment(\.userStore) private var userStore: UserStore
  @State private var viewModel = OnboardingViewModel()
  @State private var toast: Toast?

  var body: some View {
    VStack {
      backButton

      currentWizardStep

      Spacer()
    }
    .onReceive(viewModel.eventPublisher) { event in
      handleEvent(event)
    }
    .padding(.horizontal, 10)
    .task {
      await viewModel.initialLoad()
    }
    .toastView(toast: $toast)
    .withKeyboardDismissingOnTap()
  }

  private func handleEvent(_ event: OnboardingViewModel.Event) {
    switch event {
    case .didFinishOnboarding(let onboardingData):
      userStore.handlePostOnboarding(onboardingData)
    case .didFinishWithError:
      toast = Toast(style: .error, message: "Could not save data...")
    case .didFailLoadingOnboardingData:
      toast = Toast(style: .error, message: "Could not load data...")
    }
  }
}

// MARK: - Private views

extension OnboardingScreen {
  private var currentWizardStep: some View {
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
  OnboardingScreen()
}

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
  @Environment(\.appManager) private var appManager: AppManager
  @Environment(\.userStore) private var userStore: UserStore
  @State private var viewModel = OnboardingWizardViewModel()
  
  var body: some View {
    VStack {
      backButton

      header

      currentWizardStep

      Spacer()
    }
    .onReceive(viewModel.event) { event in
      handleEvent(event)
    }
    .onDisappear(perform: viewModel.cleanUp)
    .padding(.horizontal, 10)
  }

  private func handleEvent(_ event: OnboardingWizardViewModel.Event) {
    switch event {
    case .didFinishOnboarding:
      userStore.updateIsOnboarded(true)
    case .didFinishWithError(let error):
      appManager.showToast(style: .warning, message: "Could not save onboarding data.")
      MusculosLogger.logError(error, message: "Did finish onboarding with error", category: .ui)
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
        SelectLevelView(selectedLevel: $viewModel.selectedLevel)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .goal:
        SelectGoalView(selectedGoal: $viewModel.selectedGoal)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .equipment:
        SelectEquipmentView(selectedEquipment: $viewModel.selectedEquipment)
          .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
      case .permissions:
        PermissionsView(onDone: viewModel.handleNextStep)
          .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .push(from: .top)))
      }
    }
    .animation(.easeInOut(duration: 0.2), value: viewModel.wizardStep)
    .padding(.top, 24)
  }

  private var header: some View {
    Text(viewModel.wizardStep.title)
      .font(AppFont.poppins(.bold, size: 30))
      .padding(.top, 20)
      .lineLimit(10)
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
  
  private var primaryButton: some View {
    Button(action: viewModel.handleNextStep, label: {
      Text("Continue")
        .frame(maxWidth: .infinity)
    })
    .buttonStyle(PrimaryButtonStyle())
    .padding(.bottom, 20)
  }
}

#Preview {
  OnboardingWizardView()
}

//
//  OnboardingWizardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import HealthKitUI

struct OnboardingWizardView: View {
  @Environment(\.userStore) private var userStore: UserStore
  @State private var viewModel = OnboardingWizardViewModel()
    
  var body: some View {
    VStack {
      navigationBar
  
      Text(viewModel.wizardStep.title)
        .font(.header(.bold, size: 25))
        .padding(.top, 20)
      Text(headerTitle)
        .font(.header(.regular, size: 18))
        .padding(.top, 5)
      Spacer()
      
      switch viewModel.wizardStep {
      case .gender:
        SelectGenderView(selectedGender: $viewModel.selectedGender)
      case .heightAndWeight:
        SelectSizeView(selectedWeight: $viewModel.selectedWeight, selectedHeight: $viewModel.selectedHeight)
      case .goal:
        SelectGoalView(selectedGoal: $viewModel.selectedGoal)
      case .permissions:
        PermissionsView(onDone: {
            handleSubmit()
        })
      }
      
      Spacer()
      
      if viewModel.wizardStep != .permissions {
        primaryButton
      }
    }
    .padding([.leading, .trailing], 10)
  }
}

// MARK: - Private views

extension OnboardingWizardView {
  private var navigationBar: some View {
    VStack {
      HStack {
        if viewModel.wizardStep != .gender {
          Button(action: viewModel.handleBack, label: {
            Image(systemName: "arrow.backward")
              .foregroundStyle(.black)
          })
        }
        Spacer()
      }
      .padding([.leading, .trailing], 20)
    }
  }
  
  private var primaryButton: some View {
    Button(action: {
      if viewModel.canHandleNextStep {
        viewModel.handleNextStep()
      } else {
        handleSubmit()
      }
    }, label: {
      Text(buttonTitle)
        .frame(maxWidth: .infinity)
    })
    .buttonStyle(PrimaryButtonStyle())
    .padding(.bottom, 20)
  }
}

// MARK: - Helpers

extension OnboardingWizardView {
  private func handleSubmit() {
    userStore.setIsOnboarded(true)
    userStore.updateUserProfile(
      gender: viewModel.selectedGender,
      weight: viewModel.selectedWeight,
      height: viewModel.selectedHeight,
      goalId: viewModel.selectedGoal?.rawValue
    )
  }
}

// MARK: - Constants

extension OnboardingWizardView {
  private var headerTitle: String {
    "Let's optimize your experience"
  }
  
  private var buttonTitle: String {
    "Continue"
  }
}

#Preview {
    OnboardingWizardView()
}

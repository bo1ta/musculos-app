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
      ScrollView {
        VStack {
          
          Text(viewModel.wizardStep.title)
            .font(.header(.bold, size: 22))
            .padding(.top, 20)
            .lineLimit(10)
          Text(headerTitle)
            .font(.header(.regular, size: 16))
            .foregroundStyle(.gray)
            .opacity(0.7)
            .padding(.top, 5)
          
          VStack {
            switch viewModel.wizardStep {
            case .gender:
              SelectGenderView(selectedGender: $viewModel.selectedGender)
                .transition(.move(edge: .leading))
            case .heightAndWeight:
              SelectSizeView(selectedWeight: $viewModel.selectedWeight, selectedHeight: $viewModel.selectedHeight)
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
              PermissionsView(onDone: {
                handleSubmit()
              })
              .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .push(from: .top)))
            }
          }
          .animation(.easeInOut(duration: 0.2), value: viewModel.wizardStep)
          
          WhiteBackgroundCard()
        }
      }
    }
    .safeAreaInset(edge: .bottom) {
      if viewModel.wizardStep != .permissions {
        primaryButton
      }
    }
    .scrollIndicators(.hidden)
    .padding(.horizontal, 10)
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
      .padding(.horizontal, 20)
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
      goalId: 2
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

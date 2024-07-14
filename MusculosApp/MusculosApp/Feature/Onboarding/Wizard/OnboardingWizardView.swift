//
//  OnboardingWizardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI
import HealthKitUI
import Utility

struct OnboardingWizardView: View {
  @Environment(\.appManager) private var appManager: AppManager
  @Environment(\.userStore) private var userStore: UserStore
  @State private var viewModel = OnboardingWizardViewModel()
  
  var body: some View {
    VStack {
      navigationBar
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
        
        Spacer()
        
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
            PermissionsView(onDone: viewModel.handleNextStep)
              .transition(.asymmetric(insertion: .move(edge: .trailing), removal: .push(from: .top)))
          }
        }
        .animation(.easeInOut(duration: 0.2), value: viewModel.wizardStep)
        
        Spacer()
      }
    }
    .onReceive(viewModel.successSubject) { isSuccessful in
      if isSuccessful {
        userStore.updateIsOnboarded(true)
        userStore.refreshUser()
      } else {
        appManager.showToast(style: .warning, message: "Could not save onboarding data.")
      }
    }
    .onDisappear(perform: viewModel.cleanUp)
    .safeAreaInset(edge: .bottom) {
      if viewModel.wizardStep != .permissions {
        primaryButton
      }
    }
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
    Button(action: viewModel.handleNextStep, label: {
      Text(buttonTitle)
        .frame(maxWidth: .infinity)
    })
    .buttonStyle(PrimaryButtonStyle())
    .padding(.bottom, 20)
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

//
//  OnboardingWizardView.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 01.02.2024.
//

import SwiftUI

struct OnboardingWizardView: View {
  @EnvironmentObject private var userStore: UserStore

  @State private var wizardStep: OnboardingWizardStep = .gender
  @State private var selectedGender: Gender? = nil
  @State private var selectedWeight: Int? = nil
  @State private var selectedHeight: Int? = nil
  @State private var selectedGoal: Goal? = nil
  
  var body: some View {
    VStack {
      navigationBar
      
      Text(wizardStep.title)
        .font(.custom("Roboto-Bold", size: 25))
        .shadow(radius: 1)
        .padding(.top, 20)
        .padding(.bottom, 10)
      Text("Let's optimize your experience")
        .font(.custom("Roboto-Regular", size: 18))
        .shadow(radius: 1)
      Spacer()
      switch wizardStep {
      case .gender:
        SelectGenderView(selectedGender: $selectedGender)
      case .heightAndWeight:
        SelectSizeView(selectedWeight: $selectedWeight, selectedHeight: $selectedHeight)
      case .goal:
        SelectGoalView(selectedGoal: $selectedGoal)
      }
      Spacer()
      Button(action: {
        handleNextStep()
      }, label: {
        Text("Continue")
          .frame(maxWidth: .infinity)
      })
      .buttonStyle(PrimaryButton())
      .padding(.bottom, 20)
    }
    .padding([.leading, .trailing], 10)
  }
  
  private var navigationBar: some View {
    VStack {
      HStack {
        if wizardStep != .gender {
          Button {
            handleBack()
          } label: {
            Image(systemName: "arrow.backward")
              .foregroundStyle(.black)
          }
        }
        Spacer()
      }
      .padding([.leading, .trailing], 20)
    }
  }
}

extension OnboardingWizardView {
  private func handleNextStep() {
    if wizardStep == .gender {
      wizardStep = .heightAndWeight
    } else if wizardStep == .heightAndWeight {
      wizardStep = .goal
    } else {
      handleSubmit()
    }
  }
  
  private func handleBack() {
    if wizardStep == .heightAndWeight {
      wizardStep = .gender
    } else {
      wizardStep = .heightAndWeight
    }
  }
  
  private func handleSubmit() {
    userStore.isOnboarded = true
    userStore.updateUserProfile(gender: selectedGender, weight: selectedWeight, height: selectedHeight, goalId: selectedGoal?.rawValue)
  }
}

extension OnboardingWizardView {
  enum OnboardingWizardStep {
    case gender, heightAndWeight, goal

    var title: String {
      switch self {
      case .gender:
        "What is your gender?"
      case .heightAndWeight:
        "What is your weight and height?"
      case .goal:
        "What is your goal?"
      }
    }
  }
}

#Preview {
    OnboardingWizardView()
}

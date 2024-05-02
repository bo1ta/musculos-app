//
//  OnboardingWizardViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.03.2024.
//

import Foundation
import SwiftUI

class OnboardingWizardViewModel: ObservableObject {
  @Published var wizardStep: OnboardingWizardStep = .gender
  @Published var selectedGender: Gender? = nil
  @Published var selectedWeight: Int? = nil
  @Published var selectedHeight: Int? = nil
  @Published var selectedGoal: OnboardingGoal? = nil
  
  // false if we are at the last step -- at that point we have to submit the data
  var canHandleNextStep: Bool {
    wizardStep != .goal
  }
  
  func handleNextStep() {
    if wizardStep == .gender {
      wizardStep = .heightAndWeight
    } else if wizardStep == .heightAndWeight {
      wizardStep = .goal
    }
  }
  
  func handleBack() {
    if wizardStep == .heightAndWeight {
      wizardStep = .gender
    } else {
      wizardStep = .heightAndWeight
    }
  }
}

// MARK: - Step enum

extension OnboardingWizardViewModel {
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

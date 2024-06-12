//
//  OnboardingWizardViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.03.2024.
//

import Foundation
import SwiftUI

@Observable
class OnboardingWizardViewModel {
  var wizardStep: OnboardingWizardStep = .gender
  var selectedGender: Gender? = nil
  var selectedWeight: Int? = nil
  var selectedHeight: Int? = nil
  var selectedGoal: OnboardingGoal? = nil
  
  // false if we are at the last step -- at that point we have to submit the data
  var canHandleNextStep: Bool {
    wizardStep != .permissions
  }
  
  func handleNextStep() {
    if wizardStep == .gender {
      wizardStep = .heightAndWeight
    } else if wizardStep == .heightAndWeight {
      wizardStep = .goal
    } else if wizardStep == .goal {
      wizardStep = .permissions
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
    case gender, heightAndWeight, goal, permissions
    
    var title: String {
      switch self {
      case .gender:
        "What is your gender?"
      case .heightAndWeight:
        "What is your weight and height?"
      case .goal:
        "What is your goal?"
      case .permissions:
        "Permissions"
      }
    }
  }
}

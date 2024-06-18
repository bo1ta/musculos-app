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
  var selectedGoal: OnboardingData.Goal? = nil
  var selectedLevel: OnboardingData.Level? = nil
  var selectedEquipment: OnboardingData.Equipment? = nil
    
  var canHandleNextStep: Bool {
    return OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) != nil
  }
  
  func handleNextStep() {
    if let nextStep = OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) {
      wizardStep = nextStep
    } else {
      
    }
  }
  
  func handleBack() {
    guard wizardStep.rawValue > 0, let previousStep = OnboardingWizardStep(rawValue: wizardStep.rawValue - 1) else { return }
    
    wizardStep = previousStep
  }
}

// MARK: - Step enum

extension OnboardingWizardViewModel {
  enum OnboardingWizardStep: Int {
    case gender, heightAndWeight, level, goal, equipment, permissions
    
    var title: String {
      switch self {
      case .gender:
        "What is your gender?"
      case .heightAndWeight:
        "What is your weight and height?"
      case .level:
        "How would you describe your current workout experience level?"
      case .goal:
        "What is your goal?"
      case .equipment:
        "What equipment do you have access to?"
      case .permissions:
        "Permissions"
      }
    }
  }
}

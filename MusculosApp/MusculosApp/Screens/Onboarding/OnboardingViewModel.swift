//
//  OnboardingViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.03.2024.
//

import Combine
import Components
import DataRepository
import Factory
import Foundation
import Models
import SwiftUI
import Utility

// MARK: - OnboardingViewModel

@Observable
@MainActor
final class OnboardingViewModel: BaseViewModel {

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol

  // MARK: - Observed properties

  var selectedWeight = ""
  var selectedHeight = ""
  var selectedGoal: OnboardingGoal?
  var selectedLevel: OnboardingConstants.Level?
  var onboardingGoals: [OnboardingGoal] = []

  private(set) var wizardStep = OnboardingWizardStep.heightAndWeight

  private var previousStep: OnboardingWizardStep? {
    OnboardingWizardStep(rawValue: wizardStep.rawValue - 1)
  }

  private var nextStep: OnboardingWizardStep? {
    OnboardingWizardStep(rawValue: wizardStep.rawValue + 1)
  }

  func initialLoad() async {
    prepareHaptics()

    do {
      onboardingGoals = try await goalRepository.getOnboardingGoals()
    } catch {
      toastManager.showError("Could not save onboarding data")
    }
  }

  private func prepareHaptics() {
    HapticFeedbackProvider.prepareHaptic(.lightImpact)
    HapticFeedbackProvider.prepareHaptic(.heavyImpact)
    HapticFeedbackProvider.prepareHaptic(.notifySuccess)
  }

  func handleNextStep() {
    if let nextStep {
      wizardStep = nextStep
      sendHaptic(.heavyImpact)
    } else {
      saveOnboardingData()
    }
  }

  private func saveOnboardingData() {
    Task {
      let onboardingData = OnboardingData(
        weight: Int(selectedWeight),
        height: Int(selectedHeight),
        level: selectedLevel?.title,
        goal: selectedGoal)

      await userStore.updateOnboardingStatus(onboardingData)
      sendHaptic(.notifySuccess)
    }
  }

  func handleBack() {
    guard let previousStep else {
      return
    }
    wizardStep = previousStep
  }

  private func sendHaptic(_ hapticStyle: HapticFeedbackProvider.HapticFeedbackStyle) {
    HapticFeedbackProvider.haptic(hapticStyle)
  }
}

// MARK: OnboardingViewModel.OnboardingWizardStep

extension OnboardingViewModel {
  enum OnboardingWizardStep: Int {
    case heightAndWeight, level, goal, permissions

    var title: String {
      switch self {
      case .heightAndWeight:
        "Weight and height"
      case .level:
        "How would you describe your current workout experience level?"
      case .goal:
        "What is your goal?"
      case .permissions:
        "Permissions"
      }
    }
  }
}

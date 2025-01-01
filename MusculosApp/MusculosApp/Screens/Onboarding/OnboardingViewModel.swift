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
final class OnboardingViewModel {

  @ObservationIgnored
  @Injected(\.toastService) private var toastService: ToastService

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  @ObservationIgnored
  @Injected(\DataRepositoryContainer.userStore) private var userStore: UserStore

  // MARK: - Observed properties

  var selectedWeight = ""
  var selectedHeight = ""
  var selectedGoal: OnboardingGoal?
  var selectedLevel: OnboardingConstants.Level?
  var onboardingGoals: [OnboardingGoal] = []

  private(set) var wizardStep = OnboardingWizardStep.heightAndWeight
  private(set) var onboardingTask: Task<Void, Never>?

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
      toastService.error("Could not save onboarding data")
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
    onboardingTask = Task { [weak self] in
      guard let self else {
        return
      }

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

  func cleanUp() {
    onboardingTask?.cancel()
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

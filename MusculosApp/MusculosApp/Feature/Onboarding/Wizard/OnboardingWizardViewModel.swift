//
//  OnboardingWizardViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 18.03.2024.
//

import Foundation
import SwiftUI
import Factory
import Combine
import Models
import Utility
import DataRepository

@Observable
@MainActor
final class OnboardingWizardViewModel {
  @ObservationIgnored
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository

  // MARK: - Event

  enum Event {
    case didFinishOnboarding(OnboardingData)
    case didFinishWithError(Error)
    case didFailLoadingOnboardingData
  }

  private let eventSubject = PassthroughSubject<Event, Never>()

  var eventPublisher: AnyPublisher<Event, Never> {
    eventSubject.eraseToAnyPublisher()
  }

  // MARK: - Observed properties

  private(set) var wizardStep: OnboardingWizardStep = .heightAndWeight
  var selectedWeight: String = ""
  var selectedHeight: String = ""
  var selectedGoal: OnboardingGoal? = nil
  var selectedLevel: OnboardingConstants.Level? = nil
  var onboardingGoals: [OnboardingGoal] = []

  func initialLoad() async {
    prepareHaptics()

    do {
      onboardingGoals = try await goalRepository.getOnboardingGoals()
    } catch {
      sendEvent(.didFailLoadingOnboardingData)
    }
  }

  func handleNextStep() {
    if let nextStep {
      wizardStep = nextStep
      sendHaptic(.heavyImpact)
    } else {
      let onboardingData = OnboardingData(
        weight: Int(selectedWeight),
        height: Int(selectedHeight),
        level: selectedLevel?.title,
        goal: selectedGoal
      )
      sendEvent(.didFinishOnboarding(onboardingData))
      sendHaptic(.notifySuccess)
    }
  }

  func handleBack() {
    guard let previousStep else { return }
    wizardStep = previousStep
  }

  // MARK: - Private

  private var previousStep: OnboardingWizardStep? {
    return OnboardingWizardStep(rawValue: wizardStep.rawValue - 1)
  }

  private var nextStep: OnboardingWizardStep? {
    return OnboardingWizardStep(rawValue: wizardStep.rawValue + 1)
  }

  private func sendEvent(_ event: Event) {
    eventSubject.send(event)
  }

  private func prepareHaptics() {
    HapticFeedbackProvider.prepareHaptic(.lightImpact)
    HapticFeedbackProvider.prepareHaptic(.heavyImpact)
    HapticFeedbackProvider.prepareHaptic(.notifySuccess)
  }

  private func sendHaptic(_ hapticStyle: HapticFeedbackProvider.HapticFeedbackStyle) {
    HapticFeedbackProvider.haptic(hapticStyle)
  }
}

// MARK: - Step enum

extension OnboardingWizardViewModel {
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

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
import Storage
import NetworkClient

@Observable
@MainActor
final class OnboardingWizardViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\StorageContainer.dataController) private var dataController: DataController

  // MARK: - Event

  enum Event {
    case didFinishOnboarding
    case didFinishWithError(Error)
  }

  // MARK: Observed properties
  
  var wizardStep: OnboardingWizardStep = .heightAndWeight
  var selectedWeight: String = ""
  var selectedHeight: String = ""
  var selectedGoal: OnboardingData.Goal? = nil
  var selectedLevel: OnboardingData.Level? = nil

  var event: AnyPublisher<Event, Never> {
    _event.eraseToAnyPublisher()
  }

  var canHandleNextStep: Bool {
    return OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) != nil
  }
  
  func handleNextStep() {
    if let nextStep = OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) {
      wizardStep = nextStep
      HapticFeedbackProvider.haptic(.heavyImpact)
    } else {
      updateData()
    }
  }
  
  func handleBack() {
    guard wizardStep.rawValue > 0, let previousStep = OnboardingWizardStep(rawValue: wizardStep.rawValue - 1) else { return }
    
    wizardStep = previousStep
  }
  
  func cleanUp() {
    updateTask?.cancel()
    updateTask = nil
  }
  
  // MARK: - Private

  @ObservationIgnored
  private(set) var updateTask: Task<Void, Never>?

  private let _event = PassthroughSubject<Event, Never>()

  private func updateData() {
    updateTask = Task { [weak self] in
      guard let self else { return }

      do {
        try await dataController.updateUserProfile(
          weight: Int(selectedWeight),
          height: Int(selectedHeight),
          primaryGoalId: selectedGoal?.hashValue ?? 0,
          level: selectedLevel?.title,
          isOnboarded: true
        )

        if let selectedGoal, let currentUser = await dataController.getCurrentUserProfile() {
          let goal = Goal(onboardingGoal: selectedGoal, user: currentUser)
          try await dataController.addGoal(goal)
        }

        HapticFeedbackProvider.haptic(.notifySuccess)
        sendEvent(.didFinishOnboarding)
      } catch {
        HapticFeedbackProvider.haptic(.notifyError)
        sendEvent(.didFinishWithError(error))
        MusculosLogger.logError(error, message: "Could not save onboarding data", category: .coreData)
      }
    }
  }

  private func sendEvent(_ event: Event) {
    _event.send(event)
  }

  private func updateGoal() async throws {
    guard let selectedGoal else { return }
    
    try await dataController.addOnboardingGoal(selectedGoal)
  }
  
  private func updateUser() async throws {
    try await dataController.updateUserProfile(
      weight: Int(selectedWeight),
      height: Int(selectedHeight),
      primaryGoalId: selectedGoal?.hashValue ?? 0,
      level: selectedLevel?.title,
      isOnboarded: true
    )
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

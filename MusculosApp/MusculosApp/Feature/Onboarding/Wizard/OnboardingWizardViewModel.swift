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

@Observable
@MainActor
final class OnboardingWizardViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.userDataStore) private var userDataStore: UserDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol

  @ObservationIgnored
  @Injected(\.userManager) private var userManager: UserManagerProtocol

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
  var selectedEquipment: OnboardingData.Equipment? = nil

  var event: AnyPublisher<Event, Never> {
    _event.eraseToAnyPublisher()
  }

  var canHandleNextStep: Bool {
    return OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) != nil
  }
  
  func handleNextStep() {
    if let nextStep = OnboardingWizardStep(rawValue: wizardStep.rawValue + 1) {
      wizardStep = nextStep
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
    updateTask = Task {
      do {
        async let goalTask: Void = updateGoal()
        async let userTask: Void = updateUser()

        _ = try await (goalTask, userTask)
        _event.send(.didFinishOnboarding)
      } catch {
        _event.send(.didFinishWithError(error))
        MusculosLogger.logError(error, message: "Could not save onboarding data", category: .coreData)
      }
    }
  }
  
  private func updateGoal() async throws {
    guard let selectedGoal else { return }
    
    let goal = Goal(onboardingGoal: selectedGoal)
    try await goalDataStore.add(goal)
  }
  
  private func updateUser() async throws {
    var goalId: Int? // TODO: Handle Goal
    
    guard let currentUser = userManager.currentSession() else { return }

    try await userDataStore.updateProfile(
      userId: currentUser.userId,
      weight: Int(selectedWeight),
      height: Int(selectedHeight),
      primaryGoalId: goalId,
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

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

@Observable
final class OnboardingWizardViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  @Injected(\.userDataStore) private var userDataStore: UserDataStoreProtocol
  
  @ObservationIgnored
  @Injected(\.goalDataStore) private var goalDataStore: GoalDataStoreProtocol
  
  @ObservationIgnored
  private(set) var updateTask: Task<Void, Never>?
    
  // MARK: Observed properties
  
  var wizardStep: OnboardingWizardStep = .gender
  var selectedGender: Gender? = nil
  var selectedWeight: Int? = nil
  var selectedHeight: Int? = nil
  var selectedGoal: OnboardingData.Goal? = nil
  var selectedLevel: OnboardingData.Level? = nil
  var selectedEquipment: OnboardingData.Equipment? = nil
  
  var successSubject = PassthroughSubject<Bool, Never>()
    
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
  
  // MARK: - Tasks
  
  private func updateData() {
    updateTask = Task {
      do {
        try await updateGoal()
        try await updateUser()
        
        await MainActor.run {
          successSubject.send(true)
        }
      } catch {
        await MainActor.run {
          successSubject.send(false)
        }
        
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
      try await userDataStore.updateUser(
        gender: selectedGender?.rawValue,
        weight: selectedWeight,
        height: selectedHeight,
        primaryGoalId: goalId,
        level: selectedLevel?.title,
        isOnboarded: true
      )
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

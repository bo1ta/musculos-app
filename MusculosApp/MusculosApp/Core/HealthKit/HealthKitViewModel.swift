//
//  HealthKitViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//

import Foundation
import SwiftUI
import HealthKit

class HealthKitViewModel: ObservableObject {
  @Published var userStepsCount: String = ""
  @Published var sleepTime: String = ""
  @Published var isAuthorized: Bool = false
  @Published var errorMessage: String = ""
  
  private let healthStore = HKHealthStore()
  private let manager: HealthKitManager
  
  init() {
    self.manager = HealthKitManager(healthStore: healthStore)
  }
  
  @MainActor
  func requestPermissions() async {
    await manager.setUpPermissions()
    updateAuthorizationStatus()
  }
  
  @MainActor
  func loadUserSteps() async {
    do {
      if let stepsCount = try await manager.readStepCount() {
        userStepsCount = String(stepsCount)
      }
    } catch {
      errorMessage = "Could not load data"
    }
  }
  
  @MainActor
  func loadSleepAnalysis() async {
    do {
      if let sleepAnalysis = try await manager.readSleepAnalysis() {
        sleepTime = String(sleepAnalysis)
      }
    } catch {
      errorMessage = "Could not load data"
    }
  }
}

// MARK: - Private helpers

extension HealthKitViewModel {
  private func updateAuthorizationStatus() {
    let stepQuantity = HKCategoryType(.sleepAnalysis)
    
    let status = healthStore.authorizationStatus(for: stepQuantity)
    switch status {
    case .sharingAuthorized:
      isAuthorized = true
    case .notDetermined, .sharingDenied:
      isAuthorized = false
    @unknown default:
      fatalError("Unknown status")
    }
  }
}

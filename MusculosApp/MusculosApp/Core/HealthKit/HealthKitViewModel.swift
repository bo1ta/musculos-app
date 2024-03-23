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
  @Published var isAuthorized: Bool = false
  @Published var errorMessage: String = ""
  
  private let healthStore = HKHealthStore()
  private let manager = HealthKitManager()
  
  @MainActor
  func requestPermissions() async {
    guard !isAuthorized else { return }
    
    await manager.setUpPermissions(healthStore: self.healthStore)
    updateAuthorizationStatus()
  }
  
  @MainActor
  func loadUserSteps() async {
    do {
      if let stepsCount = try await self.manager.readStepCount(healthStore: self.healthStore) {
        self.userStepsCount = String(stepsCount)
      }
    } catch {
      self.errorMessage = "Could not load data"
    }
  }
}

// MARK: - Private helpers

extension HealthKitViewModel {
  private func updateAuthorizationStatus() {
    let stepQuantity = HKQuantityType(.stepCount)
    
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

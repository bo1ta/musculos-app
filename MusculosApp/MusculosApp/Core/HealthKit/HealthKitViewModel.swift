//
//  HealthKitViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//

import Foundation
import SwiftUI
import HealthKit
import Utility

@Observable
@MainActor
final class HealthKitViewModel {
  
  // MARK: - Dependencies
  
  @ObservationIgnored
  private let healthStore = HKHealthStore()
  
  @ObservationIgnored
  private let manager: HealthKitManager
  
  // MARK: - Observed properties
  
  var stepsCount: String = ""
  var sleepTime: String = ""
  var dietaryWater: String = ""
  var isAuthorized: Bool = false
  var errorMessage: String = ""
  var isLoading: Bool = false
  
  init() {
    self.manager = HealthKitManager(healthStore: healthStore)
    updateAuthorizationStatus()
  }
  
  @MainActor
  func requestPermissions() async {
    await manager.setUpPermissions()
    updateAuthorizationStatus()
  }
  
  func loadAllData() async {
    guard isAuthorized else { return }
    
    await withTaskGroup(of: Void.self) { group in
      isLoading = true
      defer { isLoading = false }
      
      group.addTask { await self.loadUserSteps() }
      group.addTask { await self.loadSleepAnalysis() }
      group.addTask { await self.loadDietaryWater() }
      
      await group.waitForAll()
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
      Logger.logError(MusculosError.badRequest, message: "Cannot update authorization status")
    }
  }
  
  @MainActor
  private func loadUserSteps() async {
    do {
      if let stepsCount = try await manager.readStepCount() {
        self.stepsCount = String(stepsCount)
      }
    } catch {
      errorMessage = "Could not load data"
    }
  }

  @MainActor
  private func loadSleepAnalysis() async {
    do {
      if let sleepTime = try await manager.readSleepAnalysis() {
        self.sleepTime = String(sleepTime)
      }
    } catch {
      errorMessage = "Could not load data"
    }
  }
  
  @MainActor
  private func loadDietaryWater() async {
    do {
      if let dietaryWater = try await manager.readDietaryWater() {
        self.dietaryWater = String(dietaryWater)
      }
    } catch {
      errorMessage = "Could not load data"
    }
  }
}

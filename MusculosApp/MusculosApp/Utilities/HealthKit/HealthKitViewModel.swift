//
//  HealthKitViewModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//

import Foundation
import SwiftUI
import HealthKit

final class HealthKitViewModel: ObservableObject {
  @Published var stepsCount: String = ""
  @Published var sleepTime: String = ""
  @Published var dietaryWater: String = ""
  @Published var isAuthorized: Bool = false
  @Published var errorMessage: String = ""
  @Published var isLoading: Bool = false
    
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
  func loadAllData() async {
    await withTaskGroup(of: Void.self) { @MainActor [weak self] group in
      guard let self else { return }
      
      self.isLoading = true
      defer { self.isLoading = false }
      
      group.addTask { await self.loadUserSteps() }
      group.addTask { await self.loadSleepAnalysis() }
      group.addTask { await self.loadDietaryWater()}
      
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
      MusculosLogger.logError(MusculosError.badRequest, message: "Cannot update authorization status", category: .healthKit)
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
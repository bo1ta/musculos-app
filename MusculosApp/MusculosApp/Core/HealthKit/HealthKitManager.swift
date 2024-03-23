//
//  HealthKitManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//

import Foundation
import HealthKit

class HealthKitManager {
  private var queryAnchor: HKQueryAnchor?
  
  init() {
    setUpQueryAnchor()
  }
}

// MARK: - Setup

extension HealthKitManager {
  func setUpPermissions(healthStore: HKHealthStore) async {
    guard HKHealthStore.isHealthDataAvailable() else { return }
    
    let stepsCount = HKQuantityType(.stepCount)
    do {
      try await healthStore.requestAuthorization(toShare: [stepsCount], read: [stepsCount])
    } catch {
      MusculosLogger.logError(error: error, message: "Error setting up health kit", category: .healthKit)
    }
  }
  
  private func setUpQueryAnchor() {
    guard let data = UserDefaults.standard.object(forKey: UserDefaultsConstants.healthKitAnchor.rawValue) as? Data else { return }
    
    do {
      let anchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
      self.queryAnchor = anchor
    } catch {
      MusculosLogger.logError(error: error, message: "Could not unarchive query anchor", category: .healthKit)
    }
  }
}

// MARK: - Read methods

extension HealthKitManager {
  func readStepCount(day: Date = Date(), healthStore: HKHealthStore) async throws -> Double? {
    let stepsCount = HKQuantityType(.stepCount)
    let startOfDay = Calendar.current.startOfDay(for: day)
    let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: day, options: .strictStartDate)
    let anchorDescription = HKAnchoredObjectQueryDescriptor(predicates: [.quantitySample(type: stepsCount, predicate: predicate)], anchor: nil)
    
    let results = try await anchorDescription.result(for: healthStore)
    updateQueryAnchor(results.newAnchor)
    
    return results.addedSamples.first?.quantity.doubleValue(for: .count())
  }
}

// MARK: - Private helpers

extension HealthKitManager {
  private func updateQueryAnchor(_ anchor: HKQueryAnchor) {
    self.queryAnchor = anchor
    
    if let anchorData = try? NSKeyedArchiver.archivedData(withRootObject: anchor as Any, requiringSecureCoding: false) {
      UserDefaults.standard.setValue(anchorData, forKey: UserDefaultsConstants.healthKitAnchor.rawValue)
    }
  }
}

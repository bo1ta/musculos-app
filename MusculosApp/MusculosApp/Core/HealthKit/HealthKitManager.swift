//
//  HealthKitManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 23.03.2024.
//

import Foundation
import HealthKit

class HealthKitManager {
  static let toSharePermissions: Set<HKSampleType> = [
    HKQuantityType(.stepCount),
    HKCategoryType(.sleepAnalysis)
  ]
  static let toReadPermissions: Set<HKSampleType> = [
    HKQuantityType(.stepCount),
    HKCategoryType(.sleepAnalysis)
  ]
  
  private let healthStore: HKHealthStore
  private var queryAnchor: HKQueryAnchor?
  
  init(healthStore: HKHealthStore) {
    self.healthStore = healthStore
    setUpQueryAnchor()
  }
}

// MARK: - Setup

extension HealthKitManager {
  func setUpPermissions() async {
    guard HKHealthStore.isHealthDataAvailable() else { return }
 
    do {
      try await healthStore.requestAuthorization(toShare: Self.toSharePermissions, read: Self.toReadPermissions)
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
  func readStepCount(day: Date = Date()) async throws -> Double? {
    let predicate = HKQuery.predicateForSamples(
      withStart: Date.yesterday,
      end: day,
      options: .strictEndDate
    )
    let anchorDescription = HKAnchoredObjectQueryDescriptor(
      predicates: [
        .quantitySample(type: HKQuantityType(.stepCount), predicate: predicate)
      ],
      anchor: queryAnchor
    )
    
    let results = try await anchorDescription.result(for: healthStore)
    let sample = results.addedSamples.first?.quantity.doubleValue(for: .count())
    MusculosLogger.logInfo(message: "Steps count: \(sample)", category: .healthKit)
    
    updateQueryAnchor(results.newAnchor)
    
    return sample
  }
  
  func readSleepAnalysis(startDate: Date = Date.yesterday, endDate: Date = Date()) async throws -> Int? {
    let predicate = HKQuery.predicateForCategorySamples(
      with: .equalTo,
      value: HKCategoryValueSleepAnalysis.inBed.rawValue
    )
    let anchorDescription = HKAnchoredObjectQueryDescriptor(
      predicates: [
        .categorySample(type: HKCategoryType(.sleepAnalysis), predicate: predicate)
      ],
      anchor: queryAnchor
    )
    
    let results = try await anchorDescription.result(for: healthStore)
    let sample = results.addedSamples.first?.value
    MusculosLogger.logInfo(message: "Sleep analysis: \(sample)", category: .healthKit)
    return sample
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

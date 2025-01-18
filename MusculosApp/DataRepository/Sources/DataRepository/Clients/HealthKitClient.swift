//
//  HealthKitClient.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 29.12.2024.
//

import Foundation
@preconcurrency import HealthKit
import Utility

public final class HealthKitClient: @unchecked Sendable {
  enum HealthKitError: Error {
    case dataNotAvailable
    case emptySamples
    case noPermissions
  }

  private static let writePermissions: Set<HKSampleType> = [
    HKQuantityType(.stepCount),
  ]

  private static let readPermissions: Set<HKSampleType> = [
    HKQuantityType(.stepCount),
    HKCategoryType(.sleepAnalysis),
  ]

  private var queryAnchor: HKQueryAnchor?
  private let healthStore: HKHealthStore

  public init() {
    healthStore = HKHealthStore()
    loadQueryAnchor()
  }

  public func requestPermissions() async throws -> Bool {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw HealthKitError.dataNotAvailable
    }

    try await healthStore.requestAuthorization(
      toShare: Self.writePermissions,
      read: Self.readPermissions)

    return try checkPermissions()
  }

  public func checkPermissions() throws -> Bool {
    guard HKHealthStore.isHealthDataAvailable() else {
      throw HealthKitError.dataNotAvailable
    }

    let authorizationStatuses = Self.readPermissions.map { type in
      healthStore.authorizationStatus(for: type)
    }

    return authorizationStatuses.allSatisfy { status in
      status == .sharingAuthorized
    }
  }

  public func getTotalStepsSinceLastWeek() async throws -> Double {
    try await getTotalSteps(startDate: DateHelper.nowPlusDays(-7), endDate: Date())
  }

  public func getTotalSteps(startDate: Date, endDate: Date) async throws -> Double {
    guard try checkPermissions() else {
      throw HealthKitError.noPermissions
    }

    let predicate = HKQuery.predicateForSamples(
      withStart: startDate,
      end: endDate,
      options: .strictEndDate)
    let anchorDescription = HKAnchoredObjectQueryDescriptor(
      predicates: [
        .quantitySample(type: HKQuantityType(.stepCount), predicate: predicate),
      ],
      anchor: queryAnchor)

    let results = try await anchorDescription.result(for: healthStore)
    updateQueryAnchor(results.newAnchor)

    let totalSteps = results.addedSamples
      .compactMap { $0.quantity.doubleValue(for: .count()) }
      .reduce(0, +)

    Logger.info(message: "HeakthKit Total Steps", properties: ["stepCount": totalSteps as Any])
    return totalSteps
  }

  public func getTotalSleepSinceLastWeek() async throws -> Int {
    try await getTotalSleep(startDate: DateHelper.nowPlusDays(-7), endDate: Date())
  }

  public func getTotalSleep(startDate _: Date, endDate _: Date) async throws -> Int {
    guard try checkPermissions() else {
      throw HealthKitError.noPermissions
    }

    let predicate = HKQuery.predicateForCategorySamples(
      with: .equalTo,
      value: HKCategoryValueSleepAnalysis.inBed.rawValue)
    let anchorDescription = HKAnchoredObjectQueryDescriptor(
      predicates: [
        .categorySample(type: HKCategoryType(.sleepAnalysis), predicate: predicate),
      ],
      anchor: queryAnchor)

    let results = try await anchorDescription.result(for: healthStore)
    updateQueryAnchor(results.newAnchor)

    let totalSleep = results.addedSamples
      .compactMap { $0.value }
      .reduce(0, +)

    Logger.info(message: "HealthKit Total Sleep", properties: ["totalSleep": totalSleep])
    return totalSleep
  }

  private func loadQueryAnchor() {
    guard let data = UserDefaults.standard.object(forKey: UserDefaultsKey.healthKitAnchor) as? Data else {
      return
    }
    do {
      queryAnchor = try NSKeyedUnarchiver.unarchivedObject(ofClass: HKQueryAnchor.self, from: data)
    } catch {
      Logger.error(error, message: "Could not unarchive query anchor")
    }
  }

  private func updateQueryAnchor(_ anchor: HKQueryAnchor) {
    queryAnchor = anchor

    if let anchorData = try? NSKeyedArchiver.archivedData(withRootObject: anchor as Any, requiringSecureCoding: false) {
      UserDefaults.standard.setValue(anchorData, forKey: UserDefaultsKey.healthKitAnchor)
    }
  }
}

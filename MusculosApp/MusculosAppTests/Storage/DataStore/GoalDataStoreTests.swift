//
//  GoalDataStoreTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 19.09.2024.
//

import Testing
import Factory
import Models
import Foundation
@testable import Storage

@Suite
public struct GoalDataStoreTests {
  @Injected(\StorageContainer.goalDataStore) var dataStore: GoalDataStoreProtocol

  @Test func getAllIsInitiallyEmpty() async throws {
    let goals = await dataStore.getAll()
    #expect(goals.isEmpty)
  }

  @Test func addGoal() async throws {
    let goal = Goal(
      name: "First goal",
      category: .general,
      frequency: .daily,
      targetValue: 0,
      endDate: nil,
      dateAdded: Date()
    )
    try await dataStore.add(goal)

    try await Task.sleep(for: .seconds(0.1))

    let goals = await dataStore.getAll()
    #expect(!goals.isEmpty)

    let firstGoal = try #require(goals.first)
    #expect(firstGoal.name == goal.name)
  }

  @Test func incrementGoalValue() async throws {
    let goal = Goal(
      name: "First goal",
      category: .general,
      frequency: .daily,
      targetValue: 0,
      endDate: nil,
      dateAdded: Date()
    )
    try await dataStore.add(goal)

    try await Task.sleep(for: .seconds(0.1))
    #expect(goal.currentValue == 0)

    try await dataStore.incrementCurrentValue(goal)
    try await Task.sleep(for: .seconds(0.1))

    let goals = await dataStore.getAll()
    print(goals.count)
    #expect(goals.first?.currentValue == 1)
  }
}

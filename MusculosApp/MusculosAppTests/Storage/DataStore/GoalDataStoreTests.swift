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
  @Injected(\StorageContainer.userDataStore) var userDataStore: UserDataStoreProtocol

  @Test func getAllIsInitiallyEmpty() async throws {
    let goals = await dataStore.getAll()
    #expect(goals.isEmpty)
  }

  @Test func addGoal() async throws {
    let user = UserProfileFactory.createProfile()
    try await populateDataStoreWithUser(user)

    let goal = Goal(
      name: "First goal",
      category: .general,
      frequency: .daily,
      targetValue: 0,
      endDate: nil,
      dateAdded: Date(),
      user: user
    )
    try await dataStore.add(goal)

    try await Task.sleep(for: .seconds(0.1))

    let goals = await dataStore.getAll()
    #expect(!goals.isEmpty)

    let firstGoal = try #require(goals.first)
    #expect(firstGoal.name == goal.name)
  }

  private func populateDataStoreWithUser(_ user: UserProfile) async throws {
    return try await userDataStore.createUser(profile: user)
  }
}

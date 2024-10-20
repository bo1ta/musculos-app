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

@Suite(.serialized)
public class GoalDataStoreTests: MusculosTestBase {
  @Test func getAllIsInitiallyEmpty() async throws {
    let goals = await GoalDataStore().getAll()
    #expect(goals.isEmpty)
  }

  @Test func addGoal() async throws {
    defer { clearStorage() }

    let user = UserProfileFactory.createProfile()
    try await populateDataStoreWithUser(user)

    let dataStore = GoalDataStore()

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

    let goals = await dataStore.getAll()
    #expect(!goals.isEmpty)

    let firstGoal = try #require(goals.first)
    #expect(firstGoal.name == goal.name)
  }

  private func populateDataStoreWithUser(_ user: UserProfile) async throws {
    return try await UserDataStore().createUser(profile: user)
  }
}

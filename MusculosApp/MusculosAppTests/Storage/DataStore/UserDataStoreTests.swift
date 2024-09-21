//
//  UserDataStoreTests.swift
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
public struct UserDataStoreTests {
  @Injected(\StorageContainer.userDataStore) private var dataStore

  @Test func createUser() async throws {
    let profile = UserProfile(
      userId: UUID(),
      email: "test@test.com",
      username: "johnny"
    )
    try await dataStore.createUser(profile: profile)
    try await Task.sleep(for: .seconds(0.1))

    await #expect(dataStore.loadProfile(userId: profile.userId)?.userId == profile.userId)
  }

  @Test func updateProfile() async throws {
    let profile = UserProfile(
      userId: UUID(),
      email: "test@test.com",
      username: "johnny",
      weight: 80
    )
    try await dataStore.createUser(profile: profile)
    try await Task.sleep(for: .seconds(0.1))

    #expect(profile.weight == 80)

    let newWeight = 100
    let newHeight = 100
    let newPrimaryGoal = 1
    let newLevel = ExerciseConstants.LevelType.beginner.rawValue
    let newIsOnboarded = true
    try await dataStore.updateProfile(
      userId: profile.userId,
      weight: newWeight,
      height: newHeight,
      primaryGoalId: newPrimaryGoal,
      level: newLevel,
      isOnboarded: newIsOnboarded
    )
    try await Task.sleep(for: .seconds(0.1))

    let fetchedProfile = try #require(await dataStore.loadProfile(userId: profile.userId))
    #expect(Int(fetchedProfile.weight ?? 0) == newWeight)
    #expect(Int(fetchedProfile.height ?? 0) == newHeight)
    #expect(fetchedProfile.primaryGoalId == newPrimaryGoal)
    #expect(fetchedProfile.level == newLevel)
    #expect(fetchedProfile.isOnboarded == newIsOnboarded)
  }
}

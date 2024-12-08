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

@Suite(.serialized)
public class UserDataStoreTests: MusculosTestBase {
  @Test func createUser() async throws {
    defer { clearStorage() }

    let dataStore = UserDataStore()

    let profile = UserProfile(
      userId: UUID(),
      email: "test@test.com",
      username: "johnny"
    )
    try await dataStore.createUser(profile: profile)

    await #expect(dataStore.loadProfile(userId: profile.userId)?.userId == profile.userId)
  }

  @Test func updateProfile() async throws {
    defer { clearStorage() }

    let dataStore = UserDataStore()

    let profile = UserProfile(
      userId: UUID(),
      email: "test@test.com",
      username: "johnny",
      weight: 80
    )
    try await dataStore.createUser(profile: profile)

    #expect(profile.weight == 80)

    let newWeight = 100
    let newHeight = 100
    let newPrimaryGoal = UUID()
    let newLevel = ExerciseConstants.LevelType.beginner.rawValue
    let newIsOnboarded = true
    try await dataStore.updateProfile(
      userId: profile.userId,
      weight: newWeight,
      height: newHeight,
      primaryGoalID: newPrimaryGoal,
      level: newLevel,
      isOnboarded: newIsOnboarded
    )

    let fetchedProfile = try #require(await dataStore.loadProfile(userId: profile.userId))
    #expect(Int(fetchedProfile.weight ?? 0) == newWeight)
    #expect(Int(fetchedProfile.height ?? 0) == newHeight)
    #expect(fetchedProfile.primaryGoalID == newPrimaryGoal)
    #expect(fetchedProfile.level == newLevel)
    #expect(fetchedProfile.isOnboarded == newIsOnboarded)
  }
}

//
//  UserDataStoreTests.swift
//  Storage
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Factory
import Foundation
import Models
import Testing
@testable import Storage

@Suite(.serialized)
public class UserDataStoreTests: MusculosTestBase {
  @Injected(\StorageContainer.userDataStore) private var dataStore

  @Test
  func userProfileByID() async throws {
    let expectedUser = UserProfileFactory.createUser()
    let user = try #require(await dataStore.userProfileByID(expectedUser.id))
    #expect(user == expectedUser)

    clearStorage()
  }

  @Test
  func userProfileByEmail() async throws {
    let expectedUser = UserProfileFactory.createUser()
    let user = try #require(await dataStore.userProfileByEmail(expectedUser.email))
    #expect(user == expectedUser)

    clearStorage()
  }

  @Test
  func updateProfile() async throws {
    let user = UserProfileFactory.createUser()
    let level = ExerciseConstants.LevelType.expert.rawValue
    let weight = 10.0
    let height = 10.0
    let primaryGoalID = GoalFactory.createGoal().id
    let isOnboarded = user.isOnboarded
    try await dataStore.updateProfile(
      userId: user.id,
      weight: weight,
      height: height,
      primaryGoalID: primaryGoalID,
      level: level,
      isOnboarded: isOnboarded)

    let updatedUser = try #require(await dataStore.userProfileByID(user.id))
    #expect(updatedUser.weight == weight)
    #expect(updatedUser.level == level)
    #expect(updatedUser.height == height)
    #expect(updatedUser.primaryGoalID == primaryGoalID)
    #expect(updatedUser.isOnboarded == isOnboarded)

    clearStorage()
  }
}

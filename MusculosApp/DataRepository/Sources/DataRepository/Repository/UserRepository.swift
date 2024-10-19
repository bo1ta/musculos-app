//
//  UserRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation
import Models
import Utility
import Storage
import NetworkClient
import Factory
import Queue

public actor UserRepository: BaseRepository {
  @Injected(\StorageContainer.userManager) private var userSessionManager: UserSessionManagerProtocol
  @Injected(\NetworkContainer.userService) private var service: UserServiceProtocol
  @Injected(\StorageContainer.userDataStore) private var dataStore: UserDataStoreProtocol
  @Injected(\StorageContainer.goalDataStore) private var goalDataStore: GoalDataStoreProtocol

  private let backgroundQueue = AsyncQueue()

  public init() {}

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    return try await service.register(email: email, password: password, username: username)
  }

  public func login(email: String, password: String) async throws -> UserSession {
    return try await service.login(email: email, password: password)
  }

  public func currentUser() async -> UserProfile? {
    guard let currentUserID = currentUserSession?.user.id else {
      return nil
    }

    let backgroundTask = backgroundQueue.addOperation(priority: .medium) { [weak self] in
      try await self?.syncCurrentUser()
    }

    if let profile = await dataStore.loadProfile(userId: currentUserID) {
      return profile
    }

    return try? await backgroundTask.value
  }

  public func updateProfile(weight: Int? = nil, height: Int? = nil, primaryGoal: Goal.Category? = nil, level: String? = nil, isOnboarded: Bool = false) async throws {
    guard
      let currentUserID = currentUserSession?.user.id,
      let currentProfile = await dataStore.loadProfile(userId: currentUserID)
    else {
      throw MusculosError.notFound
    }

    let goal = try await insertUserPrimaryGoalIfNeeded(profile: currentProfile, goalCategory: primaryGoal)
    try await dataStore.updateProfile(userId: currentUserID, weight: weight, height: height, primaryGoalID: goal?.id, level: level, isOnboarded: isOnboarded)

    backgroundQueue.addOperation { [weak self, goal] in
      try await self?.service.updateUser(weight: weight, height: height, primaryGoalID: goal?.id, level: level, isOnboarded: isOnboarded)
    }
  }

  @discardableResult private func syncCurrentUser() async throws -> UserProfile {
    let profile = try await service.currentUser()
    try await dataStore.handleObjectSync(remoteObject: profile, localObjectType: UserProfileEntity.self)
    return profile
  }

  private func insertUserPrimaryGoalIfNeeded(profile: UserProfile, goalCategory: Goal.Category?) async throws -> Goal? {
    guard let goalCategory else { return nil }

    let goal = Goal(
      name: goalCategory.label,
      category: goalCategory,
      frequency: .weekly,
      targetValue: 10,
      endDate: DateHelper.nowPlusDays(7),
      dateAdded: Date(),
      user: profile
    )
    try await goalDataStore.add(goal)
    return goal
  }
}
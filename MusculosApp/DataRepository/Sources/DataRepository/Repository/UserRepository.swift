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

public actor UserRepository: BaseRepository {
  @Injected(\NetworkContainer.userService) private var service: UserServiceProtocol
  @Injected(\StorageContainer.userDataStore) private var dataStore: UserDataStoreProtocol
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepository
  @Injected(\DataRepositoryContainer.backgroundWorker) private var backgroundWorker: BackgroundWorker

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    return try await service.register(email: email, password: password, username: username)
  }

  public func login(email: String, password: String) async throws -> UserSession {
    return try await service.login(email: email, password: password)
  }

  public func getCurrentUser() async -> UserProfile? {
    guard let currentUserID = self.currentUserID else {
      return nil
    }

    let backgroundTask = backgroundWorker.queueOperation(priority: .high) { [weak self] in
      try await self?.syncCurrentUser()
    }

    if let profile = await dataStore.loadProfile(userId: currentUserID) {
      return profile
    }

    return try? await backgroundTask.value
  }

  public func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws {
    guard
      let currentUserID = self.currentUserID,
      let currentProfile = await dataStore.loadProfile(userId: currentUserID)
    else {
      throw MusculosError.notFound
    }

    var goal: Goal?
    if let onboardingGoal = onboardingData.goal {
      goal = try await goalRepository.addFromOnboardingGoal(onboardingGoal, for: currentProfile)
    }

    try await dataStore.updateProfile(
      userId: currentUserID,
      weight: onboardingData.weight,
      height: onboardingData.height,
      primaryGoalID: goal?.goalID,
      level: onboardingData.level,
      isOnboarded: true
    )

    try await service.updateUser(
      weight: onboardingData.weight,
      height: onboardingData.height,
      primaryGoalID: goal?.goalID,
      level: onboardingData.level,
      isOnboarded: true
    )
  }

  @discardableResult private func syncCurrentUser() async throws -> UserProfile {
    let profile = try await service.currentUser()
    try await dataStore.handleObjectSync(remoteObject: profile, localObjectType: UserProfileEntity.self)
    return profile
  }
}

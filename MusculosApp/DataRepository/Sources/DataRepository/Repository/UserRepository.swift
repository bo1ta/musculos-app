//
//  UserRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Combine
import Factory
import Foundation
import Models
import NetworkClient
import Storage
import Utility

// MARK: - UserRepositoryProtocol

public protocol UserRepositoryProtocol: Sendable {
  func register(email: String, password: String, username: String) async throws -> UserSession
  func login(email: String, password: String) async throws -> UserSession
  func getCurrentUser() async throws -> UserProfile?
  func getUserByID(_ userID: UUID) async -> UserProfile?
  func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws
  func observeUserChanges(forUserID userID: UUID) -> EntityListener<UserProfileEntity>
}

// MARK: - UserRepository

public struct UserRepository: @unchecked Sendable, BaseRepository, UserRepositoryProtocol {
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol
  @Injected(\NetworkContainer.userService) private var service: UserServiceProtocol

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    let session = try await service.register(email: email, password: password, username: username)

    let userProfile = UserProfile(userId: session.user.id, email: email, username: username)
    try await coreDataStore.importModel(userProfile, of: UserProfileEntity.self)

    return session
  }

  public func login(email: String, password: String) async throws -> UserSession {
    try await service.login(email: email, password: password)
  }

  public func getCurrentUser() async throws -> UserProfile? {
    guard let currentUserID else {
      throw MusculosError.unexpectedNil
    }

    let backgroundTask = backgroundWorker.queueOperation(priority: .high) {
      try await syncCurrentUser()
    }

    if let profile = await coreDataStore.userProfileByID(currentUserID) {
      return profile
    }

    return try? await backgroundTask.value
  }

  public func getUserByID(_ userID: UUID) async -> UserProfile? {
    await coreDataStore.userProfileByID(userID)
  }

  @discardableResult
  public func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws {
    guard
      let currentUserID,
      let currentProfile = await coreDataStore.userProfileByID(currentUserID)
    else {
      throw MusculosError.unexpectedNil
    }

    var goal: Goal?
    if let onboardingGoal = onboardingData.goal {
      goal = try await goalRepository.addFromOnboardingGoal(onboardingGoal, for: currentProfile)
    }

    try await coreDataStore.updateProfile(
      userId: currentUserID,
      weight: onboardingData.weight,
      height: onboardingData.height,
      primaryGoalID: goal?.id,
      level: onboardingData.level,
      isOnboarded: true)

    _ = try await service.updateUser(
      weight: onboardingData.weight,
      height: onboardingData.height,
      primaryGoalID: goal?.id,
      level: onboardingData.level,
      isOnboarded: true)
  }

  public func observeUserChanges(forUserID userID: UUID) -> EntityListener<UserProfileEntity> {
    coreDataStore.userEntityListener(forID: userID)
  }

  @discardableResult
  private func syncCurrentUser() async throws -> UserProfile {
    let profile = try await service.currentUser()
    try await coreDataStore.importModel(profile, of: UserProfileEntity.self)
    return profile
  }
}

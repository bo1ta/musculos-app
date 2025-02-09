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
  func entityPublisherForUserID(_ userID: UUID) -> EntityPublisher<UserProfileEntity>
  @discardableResult
  func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws -> UserProfile
}

// MARK: - UserRepository

public struct UserRepository: @unchecked Sendable, BaseRepository, UserRepositoryProtocol {
  @Injected(\DataRepositoryContainer.goalRepository) private var goalRepository: GoalRepositoryProtocol
  @Injected(\NetworkContainer.userService) private var service: UserServiceProtocol
  @Injected(\StorageContainer.userDataStore) var dataStore: UserDataStoreProtocol
  @Injected(\DataRepositoryContainer.syncManager) var syncManager: SyncManagerProtocol

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    let session = try await service.register(email: email, password: password, username: username)

    let userProfile = UserProfile(id: session.user.id, email: email, username: username)
    try await syncManager.insertToStorage(userProfile, ofType: UserProfileEntity.self)

    return session
  }

  public func login(email: String, password: String) async throws -> UserSession {
    try await service.login(email: email, password: password)
  }

  public func getCurrentUser() async throws -> UserProfile? {
    let userID = try requireCurrentUser()

    if let localUser = await dataStore.userProfileByID(userID) {
      return localUser
    } else {
      let remoteUser = try await service.currentUser()
      syncManager.syncStorage(remoteUser, ofType: UserProfileEntity.self)
      return remoteUser
    }
  }

  public func getUserByID(_ userID: UUID) async -> UserProfile? {
    try? await fetch(
      forType: UserProfileEntity.self,
      localTask: { await dataStore.userProfileByID(userID) },
      remoteTask: { try await service.currentUser() })
  }

  @discardableResult
  public func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws -> UserProfile {
    guard
      let currentUserID,
      let currentProfile = await dataStore.userProfileByID(currentUserID)
    else {
      throw MusculosError.unexpectedNil
    }

    var goal: Goal?
    if let onboardingGoal = onboardingData.goal {
      goal = try await goalRepository.addFromOnboardingGoal(onboardingGoal, for: currentProfile)
    }

    try await dataStore.updateProfile(
      userId: currentUserID,
      weight: Double(onboardingData.weight ?? 0),
      height: Double(onboardingData.height ?? 0),
      primaryGoalID: goal?.id,
      level: onboardingData.level,
      isOnboarded: true)

    return try await service.updateUser(
      weight: onboardingData.weight,
      height: onboardingData.height,
      primaryGoalID: goal?.id,
      level: onboardingData.level,
      isOnboarded: true)
  }

  public func entityPublisherForUserID(_ userID: UUID) -> EntityPublisher<UserProfileEntity> {
    dataStore.userPublisherForID(userID)
  }
}

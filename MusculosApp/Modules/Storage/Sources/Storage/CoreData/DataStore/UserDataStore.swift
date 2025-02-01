//
//  UserDataStore.swift
//  Storage
//
//  Created by Solomon Alexandru on 01.02.2025.
//

import Factory
import Foundation
import Models
import Principle
import Utility

// MARK: - UserDataStoreProtocol

public protocol UserDataStoreProtocol: Sendable {
  static func userProfileEntity(byID userID: UUID, on storage: StorageType) -> UserProfileEntity?
  func userProfileByID(_ userID: UUID) async -> UserProfile?
  func userProfileByEmail(_ email: String) async -> UserProfile?
  func updateProfile(
    userId: UUID,
    weight: Int?,
    height: Int?,
    primaryGoalID: UUID?,
    level: String?,
    isOnboarded: Bool) async throws
  func userPublisherForID(_ userID: UUID) -> EntityPublisher<UserProfileEntity>
  func userExperienceEntryByID(_ id: UUID) async -> UserExperienceEntry?
  func userExperienceForUserID(_ userID: UUID) async -> UserExperience?
}

// MARK: - UserDataStore

public struct UserDataStore: UserDataStoreProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) public var storageManager: StorageManagerType

  public init() { }

  public func userProfileByID(_ userID: UUID) async -> UserProfile? {
    let predicate: NSPredicate = \UserProfileEntity.uniqueID == userID
    return await storageManager.getFirstEntity(UserProfileEntity.self, predicate: predicate)
  }

  public func userProfileByEmail(_ email: String) async -> UserProfile? {
    let predicate: NSPredicate = \UserProfileEntity.email == email
    return await storageManager.getFirstEntity(UserProfileEntity.self, predicate: predicate)
  }

  public func updateProfile(
    userId: UUID,
    weight: Int?,
    height: Int?,
    primaryGoalID: UUID?,
    level: String?,
    isOnboarded: Bool = false)
    async throws
  {
    try await storageManager.performWrite { storage in
      guard let userProfile = Self.userProfileEntity(byID: userId, on: storage) else {
        throw MusculosError.unexpectedNil
      }

      userProfile.level = level
      userProfile.isOnboarded = isOnboarded

      if let weight {
        userProfile.weight = weight as NSNumber
      }

      if let height {
        userProfile.height = height as NSNumber
      }

      if let primaryGoalID {
        userProfile.primaryGoalID = primaryGoalID
      }
    }
  }

  public func userPublisherForID(_ userID: UUID) -> EntityPublisher<UserProfileEntity> {
    storageManager.createEntityPublisher(matching: \UserProfileEntity.uniqueID == userID)
  }

  public static func userProfileEntity(byID userID: UUID, on storage: StorageType) -> UserProfileEntity? {
    storage.firstObject(of: UserProfileEntity.self, matching: \UserProfileEntity.uniqueID == userID)
  }

  public func userExperienceEntryByID(_ id: UUID) async -> UserExperienceEntry? {
    await storageManager.getFirstEntity(UserExperienceEntryEntity.self, predicate: \UserExperienceEntryEntity.uniqueID == id)
  }

  public func userExperienceForUserID(_ userID: UUID) async -> UserExperience? {
    await storageManager.performRead { storage in
      guard
        let userProfile = Self.userProfileEntity(byID: userID, on: storage),
        let experience = userProfile.userExperience
      else {
        return nil
      }

      return experience.toReadOnly()
    }
  }
}

//
//  UserDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData
import Models
import Utility

public protocol UserDataStoreProtocol: BaseDataStore, Sendable {
  func createUser(profile: UserProfile) async throws
  func updateProfile(userId: UUID, weight: Int?, height: Int?, primaryGoalID: UUID?, level: String?, isOnboarded: Bool) async throws
  func loadProfile(userId: UUID) async -> UserProfile?
  func loadProfileByEmail(_ email: String) async -> UserProfile?
}

public struct UserDataStore: UserDataStoreProtocol {

  public init() { }
  
  public func createUser(profile: UserProfile) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      let userProfile = writerDerivedStorage.insertNewObject(ofType: UserProfileEntity.self)
      userProfile.userId = profile.userId
      userProfile.username = profile.username
      userProfile.email = profile.email
    }
  }
  
  public func updateProfile(userId: UUID, weight: Int?, height: Int?, primaryGoalID: UUID?, level: String?, isOnboarded: Bool = false) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard let userProfile = writerDerivedStorage.firstObject(
        of: UserProfileEntity.self,
        matching: PredicateFactory.userProfileById(userId)
      ) else {
        throw MusculosError.notFound
      }

      userProfile.level = level
      userProfile.isOnboarded = isOnboarded

      if let weight {
        userProfile.weight = NSNumber(integerLiteral: weight)
      }
      
      if let height {
        userProfile.height = NSNumber(integerLiteral: height)
      }
      
      if let primaryGoalID {
        userProfile.primaryGoalID = primaryGoalID
      }
      
    }
  }
  
  public func loadProfile(userId: UUID) async -> UserProfile? {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .firstObject(
          of: UserProfileEntity.self,
          matching: PredicateFactory.userProfileById(userId)
        )?.toReadOnly()
    }
  }

  public func loadProfileByEmail(_ email: String) async -> UserProfile? {
    return await storageManager.performRead { viewStorage in
      return viewStorage
        .firstObject(
          of: UserProfileEntity.self,
          matching: PredicateFactory.userProfileByEmail(email)
        )?.toReadOnly()
    }
  }
}

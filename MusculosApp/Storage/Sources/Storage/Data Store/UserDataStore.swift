//
//  UserDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData
import Models

public protocol UserDataStoreProtocol: Sendable {
  func createUser(profile: UserProfile) async throws
  func updateProfile(userId: UUID, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws
  func loadProfile(userId: UUID) async -> UserProfile?
  func loadProfileByEmail(_ email: String) async -> UserProfile?
}

public struct UserDataStore: BaseDataStore, UserDataStoreProtocol, Sendable {

  public init() { }
  
  public func createUser(profile: UserProfile) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      let userProfile = writerDerivedStorage.insertNewObject(ofType: UserProfileEntity.self)
      userProfile.userId = profile.userId.uuidString
      userProfile.username = profile.username
      userProfile.email = profile.email
    }
    
    await storageManager.saveChanges()
  }
  
  public func updateProfile(userId: UUID, weight: Int? = nil, height: Int? = nil, primaryGoalId: Int? = nil, level: String?, isOnboarded: Bool = false) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard 
        let userProfile = UserProfileEntity.userFrom(userId: userId.uuidString, on: writerDerivedStorage)
      else { return }
      
      userProfile.level = level
      
      if let weight {
        userProfile.weight = NSNumber(integerLiteral: weight)
      }
      
      if let height {
        userProfile.height = NSNumber(integerLiteral: height)
      }
      
      if let primaryGoalId {
        userProfile.primaryGoalId = NSNumber(integerLiteral: primaryGoalId)
      }
    }
    
    await storageManager.saveChanges()
  }
  
  public func loadProfile(userId: UUID) async -> UserProfile? {
    return await storageManager.performRead { viewStorage in
      let predicate = UserProfileEntity.CommonPredicate.currentUser(userId.uuidString).nsPredicate
      return viewStorage
        .firstObject(
          of: UserProfileEntity.self,
          matching: predicate)?
        .toReadOnly()
    }
  }

  public func loadProfileByEmail(_ email: String) async -> UserProfile? {
    return await storageManager.performRead { viewStorage in
      let predicate = PredicateFactory.userProfileByEmail(email)
      return viewStorage
        .firstObject(of: UserProfileEntity.self, matching: predicate)?
        .toReadOnly()
    }
  }
}

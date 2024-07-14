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
  func createUser(person: UserProfile) async throws
  func updateProfile(userId: UUID, gender: String?, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws
  func loadProfile(userId: UUID) async -> UserProfile?
}

public struct UserDataStore: BaseDataStore, UserDataStoreProtocol {
  
  public init() { }
  
  public func createUser(person: UserProfile) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      let userProfile = writerDerivedStorage.insertNewObject(ofType: UserProfileEntity.self)
      userProfile.userId = person.userId.uuidString
      userProfile.username = person.username
      userProfile.email = person.email
      userProfile.fullName = person.fullName
    }
    
    await storageManager.saveChanges()
  }
  
  public func updateProfile(userId: UUID, gender: String? = nil, weight: Int? = nil, height: Int? = nil, primaryGoalId: Int? = nil, level: String?, isOnboarded: Bool = false) async throws {
    try await storageManager.performWrite { writerDerivedStorage in
      guard 
        let userProfile = writerDerivedStorage.firstObject(
        of: UserProfileEntity.self,
        matching: UserProfileEntity.CommonPredicate.currentUser(userId).nsPredicate)
      else { return }
      
      userProfile.gender = gender
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
    let predicate = UserProfileEntity.CommonPredicate.currentUser(userId).nsPredicate
    
    return await storageManager.performRead { viewStorage in
      
      let allbojects = viewStorage.allObjects(ofType: UserProfileEntity.self, matching: nil, sortedBy: nil).compactMap { $0.toReadOnly() }
      print(allbojects)
      allbojects.forEach { print($0.userId) }
      
      
      return viewStorage
        .firstObject(
          of: UserProfileEntity.self,
          matching: predicate)?
        .toReadOnly()
    }
  }
}

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
  func createUser(person: User) async throws
  func updateUser(gender: String?, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws
  func loadCurrentUser() async -> User?
}

public struct UserDataStore: BaseDataStore, UserDataStoreProtocol {
  
  public init() { }
  
  public func createUser(person: User) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      let userEntity = writerDerivedStorage.insertNewObject(ofType: UserEntity.self)
      userEntity.username = person.username
      userEntity.email = person.email
      userEntity.fullName = person.fullName
      userEntity.isCurrentUser = true
    }
    
    await storageManager.saveChanges()
  }
  
  public func updateUser(gender: String? = nil, weight: Int? = nil, height: Int? = nil, primaryGoalId: Int? = nil, level: String?, isOnboarded: Bool = false) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      guard let userEntity = UserEntity.currentUser(with: writerDerivedStorage) else { return }
      
      userEntity.gender = gender
      userEntity.level = level
      userEntity.isOnboarded = isOnboarded
      
      if let weight {
        userEntity.weight = NSNumber(integerLiteral: weight)
      }
      
      if let height {
        userEntity.height = NSNumber(integerLiteral: height)
      }
      
      if let primaryGoalId {
        userEntity.primaryGoalId = NSNumber(integerLiteral: primaryGoalId)
      }
    }
    
    await storageManager.saveChanges()
  }
  
  public func loadCurrentUser() async -> User? {
    return await storageManager.performReadOperation { viewStorage in
      
      guard let person = viewStorage
        .firstObject(of: UserEntity.self, matching: UserEntity.CommonPredicate.currentUser.nsPredicate) else { return nil }
      
      return person.toReadOnly()
    }
  }
}

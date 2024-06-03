//
//  UserDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

protocol UserDataStoreProtocol {
  func createUser(person: Person) async throws
  func updateUser(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async throws
  func loadCurrentPerson() async -> Person?
}

struct UserDataStore: BaseDataStore, UserDataStoreProtocol {
  func createUser(person: Person) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      let userEntity = writerDerivedStorage.insertNewObject(ofType: UserEntity.self)
      userEntity.username = person.username
      userEntity.email = person.email
      userEntity.fullName = person.fullName
      userEntity.isCurrentUser = true
    }
    
    storageManager.saveChanges()
  }
  
  func updateUser(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async throws {
    try await storageManager.performWriteOperation { writerDerivedStorage in
      guard let userEntity = UserEntity.currentUser(with: writerDerivedStorage) else { return }
      
      userEntity.gender = gender?.rawValue
      if let weight {
        userEntity.weight = NSNumber(integerLiteral: weight)
      }
      if let height {
        userEntity.height = NSNumber(integerLiteral: height)
      }
      if let goalId {
        userEntity.goalId = NSNumber(integerLiteral: goalId)
      }
    }
    
    storageManager.saveChanges()
  }
  
  @MainActor
  func loadCurrentPerson() async -> Person? {
    return await storageManager.performReadOperation { viewStorage in
      if let userEntity = UserEntity.currentUser(with: viewStorage) {
        return userEntity.toReadOnly()
      }
      return nil
    }
  }
}

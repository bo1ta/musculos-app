//
//  UserDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

struct UserDataStore: BaseDataStore, UserDataStoreProtocol {
  func createUser(person: Person) async {
    await writerDerivedStorage.performAndSave {
      let userEntity = writerDerivedStorage.insertNewObject(ofType: UserEntity.self)
      userEntity.username = person.username
      userEntity.email = person.email
      userEntity.fullName = person.fullName
      userEntity.isCurrentUser = true
    }
    await viewStorage.performAndSave { }
  }
  
  func updateUser(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async {
    await writerDerivedStorage.performAndSave {
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
       
    await viewStorage.performAndSave { }
  }
  
  @MainActor
  func loadCurrentPerson() -> Person? {
    if let userEntity = UserEntity.currentUser(with: viewStorage) {
      return userEntity.toReadOnly()
    }
    return nil
  }
}

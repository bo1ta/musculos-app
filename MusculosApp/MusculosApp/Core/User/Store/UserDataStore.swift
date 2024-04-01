//
//  UserDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

final class UserDataStore: BaseDataStore, Sendable {
  func createUserProfile(person: Person) async {
    await writerDerivedStorage.performAndSave { [unowned self] in
      let userProfile = writerDerivedStorage.insertNewObject(ofType: UserProfile.self)
      userProfile.username = person.username
      userProfile.email = person.email
      userProfile.fullName = person.fullName
      userProfile.isCurrentUser = true
    }
    await viewStorage.performAndSave { }
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async {
    await writerDerivedStorage.performAndSave { [unowned self] in
      guard let userProfile = UserProfile.currentUserProfile(storage: writerDerivedStorage) else { return }
  
      userProfile.gender = gender?.rawValue
      if let weight {
        userProfile.weight = NSNumber(integerLiteral: weight)
      }
      if let height {
        userProfile.height = NSNumber(integerLiteral: height)
      }
      if let goalId {
        userProfile.goalId = NSNumber(integerLiteral: goalId)
      }
    }
       
    await viewStorage.performAndSave { }
  }
}

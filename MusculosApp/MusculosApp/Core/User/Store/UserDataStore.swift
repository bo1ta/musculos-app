//
//  CoreDataManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

class UserDataStore: BaseDataStore {
  func createUserProfile(person: Person) async {
    await writeOnlyContext.performAndSaveIfNeeded { [weak self] in
      guard let self else { return }
      
      let userProfile = UserProfile(context: self.writeOnlyContext)
      userProfile.username = person.username
      userProfile.email = person.email
      userProfile.fullName = person.fullName
      userProfile.isCurrentUser = true
    }
    
    await mainContext.performAndSaveIfNeeded()
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async {
    await writeOnlyContext.performAndSaveIfNeeded { [weak self] in
      guard let self, let userProfile = UserProfile.currentUserProfile(context: self.writeOnlyContext) else { return }
  
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
       
    await mainContext.performAndSaveIfNeeded()
  }
}

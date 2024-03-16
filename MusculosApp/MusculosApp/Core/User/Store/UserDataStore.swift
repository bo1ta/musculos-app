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
    let userProfile = UserProfile(context: writeOnlyContext)
    userProfile.username = person.username
    userProfile.email = person.email
    userProfile.fullName = person.fullName
    userProfile.isCurrentUser = true
    
    await writeOnlyContext.saveIfNeeded()
    await mainContext.saveIfNeeded()
  }
  
  func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) async {
    guard let userProfile = await UserProfile.currentUserProfile(context: writeOnlyContext) else { return }
    
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
    
    await writeOnlyContext.saveIfNeeded()
    await mainContext.saveIfNeeded()
  }
}

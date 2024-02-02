//
//  CoreDataManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

class CoreDataManager {
  static func createUserProfile(person: Person) {
    let userProfile = UserProfile(context: CoreDataStack.shared.backgroundContext)
    userProfile.username = person.username
    userProfile.email = person.email
    userProfile.fullName = person.fullName
    userProfile.isCurrentUser = true

    Task { await CoreDataStack.shared.saveBackgroundContext() }
  }
  
  static func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) {
    Task {
      guard let userProfile = await UserProfile.currentUserProfile(context: CoreDataStack.shared.backgroundContext) else { return }

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
  
      await CoreDataStack.shared.saveBackgroundContext()
      await CoreDataStack.shared.saveMainContext()
    }
  }
}

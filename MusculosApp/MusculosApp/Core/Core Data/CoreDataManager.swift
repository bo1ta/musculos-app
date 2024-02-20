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
      userProfile.weight = weight ?? 0
      userProfile.height = height ?? 0
      userProfile.goalId = goalId ?? 0
  
      await CoreDataStack.shared.saveBackgroundContext()
      await CoreDataStack.shared.saveMainContext()
    }
  }
}

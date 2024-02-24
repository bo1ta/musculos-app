//
//  CoreDataManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//

import Foundation
import CoreData

class CoreDataManager {
  private static var managedObjectContext: NSManagedObjectContext {
    CoreDataStack.shared.userPrivateContext
  }
  
  static func createUserProfile(person: Person) {
    let userProfile = UserProfile(context: managedObjectContext)
    userProfile.username = person.username
    userProfile.email = person.email
    userProfile.fullName = person.fullName
    userProfile.isCurrentUser = true

    Task {
      await CoreDataStack.saveContext(managedObjectContext)
      CoreDataStack.shared.asyncSaveMainContext()
    }
  }
  
  static func updateUserProfile(gender: Gender?, weight: Int?, height: Int?, goalId: Int?) {
    Task {
      guard let userProfile = await UserProfile.currentUserProfile(context: managedObjectContext) else { return }
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
  
      await CoreDataStack.saveContext(managedObjectContext)
      CoreDataStack.shared.asyncSaveMainContext()
    }
  }
}

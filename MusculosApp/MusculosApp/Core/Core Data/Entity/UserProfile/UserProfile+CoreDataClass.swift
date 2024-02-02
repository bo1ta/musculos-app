//
//  UserProfile+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//
//

import Foundation
import CoreData

@objc(UserProfile)
public class UserProfile: NSManagedObject {
  static func currentUserProfile(context: NSManagedObjectContext) async -> UserProfile? {
    await context.perform {
      let fetchRequest = UserProfile.fetchRequest()
      fetchRequest.predicate = NSPredicate(format: "isCurrentUser == true")
      do {
        let userProfiles: [UserProfile]? = try context.fetch(fetchRequest)
        return userProfiles?.first
      } catch {
        MusculosLogger.logError(error: error, message: "Current user profile error", category: .coreData)
        return nil
      }
    }
  }
}

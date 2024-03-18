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
public class UserProfile: NSManagedObject, Codable, UserProfileProvider {
  @NSManaged public var gender: String?
  @NSManaged public var fullName: String?
  @NSManaged public var username: String?
  @NSManaged public var email: String?
  @NSManaged public var weight: NSNumber?
  @NSManaged public var height: NSNumber?
  @NSManaged public var goalId: NSNumber?
  @NSManaged public var isCurrentUser: Bool
  @NSManaged public var synchronized: NSNumber
  @NSManaged public var updatedAt: Date
  
  public var synchronizationState: SynchronizationState {
    get {
      SynchronizationState(rawValue: synchronized.intValue) ?? .notSynchronized
    }

    set {
      synchronized = NSNumber(integerLiteral: newValue.rawValue)
    }
  }
  
  enum CodingKeys: String, CodingKey {
    case gender, username, email, weight, height, goalId, isCurrentUser, synchronized
    case updatedAt = "updated_at"
    case fullName = "full_name"
  }
  
  public required convenience init(from decoder: Decoder) throws {
    guard let context = decoder.userInfo[.managedObjectContext] as? NSManagedObjectContext else {
      fatalError("Managed object context not found!")
    }
    
    self.init(context: context)
    
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.fullName = try container.decode(String.self, forKey: .fullName)
    self.email = try container.decode(String.self, forKey: .email)
    self.username = try container.decode(String.self, forKey: .username)
  
    if let weight = try? container.decode(Int.self, forKey: .weight) {
      self.weight = NSNumber(integerLiteral: weight)
    }
    if let height = try? container.decode(Int.self, forKey: .height) {
      self.height = NSNumber(integerLiteral: height)
    }
    if let goalId = try? container.decode(Int.self, forKey: .goalId) {
      self.goalId = NSNumber(integerLiteral: goalId)
    }
  }
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(fullName, forKey: .fullName)
    try container.encode(email, forKey: .email)
    try container.encode(username, forKey: .username)
    try container.encode(goalId?.intValue, forKey: .goalId)
    try container.encode(weight?.intValue, forKey: .weight)
    try container.encode(height?.intValue, forKey: .height)
  }
  
  public class func fetchRequest() -> NSFetchRequest<UserProfile> {
    return NSFetchRequest<UserProfile>(entityName: "UserProfile")
  }
  
  @MainActor
  static func currentUserProfile(context: NSManagedObjectContext) async -> UserProfile? {
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

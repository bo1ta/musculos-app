//
//  UserProfile+CoreDataProperties.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.02.2024.
//
//

import Foundation
import CoreData


extension UserProfile {
  @nonobjc public class func fetchRequest() -> NSFetchRequest<UserProfile> {
    return NSFetchRequest<UserProfile>(entityName: "UserProfile")
  }
  
  @NSManaged public var gender: String?
  @NSManaged public var fullName: String?
  @NSManaged public var username: String?
  @NSManaged public var email: String?
  @NSManaged public var weight: NSNumber?
  @NSManaged public var height: NSNumber?
  @NSManaged public var goalId: NSNumber?
  @NSManaged public var isCurrentUser: Bool
}

extension UserProfile : Identifiable { }

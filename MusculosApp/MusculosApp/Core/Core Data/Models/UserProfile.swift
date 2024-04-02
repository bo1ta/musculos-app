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
  
  public class func fetchRequest() -> NSFetchRequest<UserProfile> {
    return NSFetchRequest<UserProfile>(entityName: "UserProfile")
  }
  
  /// Should be used only on main thread
  ///
  static var currentUserProfile: UserProfile? {
    let viewStorage = CoreDataStack.shared.viewStorage
    return viewStorage.firstObject(of: UserProfile.self, matching: CommonPredicate.currentUser.nsPredicate)
  }
  
  static func currentUserProfile(storage: StorageType) -> UserProfile? {
    return storage.firstObject(of: UserProfile.self, matching: CommonPredicate.currentUser.nsPredicate)
  }
}

extension UserProfile {
  enum CommonPredicate {
    case currentUser
    
    var nsPredicate: NSPredicate {
      switch self {
      case .currentUser:
        NSPredicate(format: "isCurrentUser == true")
      }
    }
  }
}

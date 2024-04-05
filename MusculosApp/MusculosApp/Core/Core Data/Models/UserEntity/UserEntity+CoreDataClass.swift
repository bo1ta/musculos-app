//
//  UserEntity+CoreDataClass.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 05.04.2024.
//
//

import Foundation
import CoreData

@objc(UserEntity)
public class UserEntity: NSManagedObject {
  public var synchronizationState: SynchronizationState {
    get {
      SynchronizationState(rawValue: synchronized.intValue) ?? .notSynchronized
    }
    
    set {
      synchronized = NSNumber(integerLiteral: newValue.rawValue)
    }
  }
  
  /// Only for main thread
  ///
  static var currentUser: UserEntity? {
    let viewStorage = CoreDataStack.shared.viewStorage
    return viewStorage.firstObject(of: UserEntity.self, matching: CommonPredicate.currentUser.nsPredicate)
  }
  
  static func currentUser(with context: StorageType) -> UserEntity? {
    return context.firstObject(of: UserEntity.self, matching: CommonPredicate.currentUser.nsPredicate)
  }
}

// MARK: - Common predicate

extension UserEntity {
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

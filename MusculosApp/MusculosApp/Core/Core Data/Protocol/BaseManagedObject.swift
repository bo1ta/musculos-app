//
//  BaseManagedObject.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.03.2024.
//

import Foundation
import CoreData

protocol BaseManagedObject: NSManagedObject {
  func toContext<T: NSManagedObject>(_ managedObjectContext: NSManagedObjectContext) -> T?
}

extension BaseManagedObject {
  func toContext<T: NSManagedObject>(_ managedObjectContext: NSManagedObjectContext) -> T? {    
    var result: T?
    
    do {
      try managedObjectContext.performAndWait {
        if let existingObject = try managedObjectContext.existingObject(with: self.objectID) as? T {
          result = existingObject
        }
      }
    } catch {
     MusculosLogger.logError(error: error, message: "Could not convert context", category: .coreData)
   }
    return result
  }
}

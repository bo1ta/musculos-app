//
//  BaseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Foundation
import CoreData

protocol BaseDataStore {
  var writeOnlyContext: NSManagedObjectContext { get }
  var mainContext: NSManagedObjectContext { get }
}

extension BaseDataStore {
  var writeOnlyContext: NSManagedObjectContext {
    CoreDataStack.shared.writeOnlyContext
  }
  
  var mainContext: NSManagedObjectContext {
    CoreDataStack.shared.mainContext
  }
}

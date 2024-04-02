//
//  DummyStack.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 29.03.2024.
//

import Foundation
import CoreData
@testable import MusculosApp

class DummyStack: StorageManagerType {
  public lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MusculosDataStore")
    let description = container.persistentStoreDescriptions.first
    description?.type = NSInMemoryStoreType
    description?.shouldAddStoreAsynchronously = false
    
    container.loadPersistentStores { _, error in
      if let error = error {
        MusculosLogger.logError(error, message: "Failed to load persistent store", category: .coreData)
      }
    }
    
    return container
  }()
  
  var viewStorage: StorageType {
    persistentContainer.viewContext
  }
  
  var writerDerivedStorage: StorageType {
    persistentContainer.viewContext
  }
  
  func saveDerivedType(_ derivedStorage: any StorageType) async {
    derivedStorage.saveIfNeeded()
  }
  
  func reset() {}
}

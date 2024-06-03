//
//  InMemoryStorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
import CoreData

class InMemoryStorageManager: StorageManager {
  private var _persistentContainer: NSPersistentContainer?
  
  override var persistentContainer: NSPersistentContainer {
    get {
      if let persistentContainer = _persistentContainer {
        return persistentContainer
      } else {
        let container = NSPersistentContainer(name: "MusculosDataStore")
        let description = container.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        description?.shouldAddStoreAsynchronously = false
        
        container.loadPersistentStores { _, error in
          if let error = error {
            MusculosLogger.logError(error, message: "Failed to load persistent store", category: .coreData)
          }
        }
        _persistentContainer = container
        
        return container
      }
    }
    
    set { }
  }
}

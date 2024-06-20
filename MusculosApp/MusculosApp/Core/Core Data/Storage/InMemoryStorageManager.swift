//
//  InMemoryStorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
import CoreData
import Utilities

class InMemoryStorageManager: StorageManager {
  private var _persistentContainer: NSPersistentContainer?
  
  override init() {}
  
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
  
  override func performWriteOperation(_ task: @escaping (any StorageType) throws -> Void) async throws {
    try await super.performWriteOperation(task)
    await saveChanges()
  }
  
  override func deleteAllStoredObjects() {
    let viewContext = persistentContainer.viewContext
    
    for entity in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      guard let entityName = entity.name else { continue }
      
      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
      
      do {
        let objects = try viewContext.fetch(fetchRequest)
        for object in objects {
          viewContext.delete(object)
        }
      } catch {
        print("Failed to fetch objects for entity \(entityName): \(error)")
      }
    }
  }
}

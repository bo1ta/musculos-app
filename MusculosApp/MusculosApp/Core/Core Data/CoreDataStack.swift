//
//  CoreDataStack.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

final class CoreDataStack: StorageManagerType {
  public lazy var persistentContainer: NSPersistentContainer = {
    let container = NSPersistentContainer(name: "MusculosDataStore")
    
    let description = container.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType
    description?.shouldMigrateStoreAutomatically = true
    description?.shouldInferMappingModelAutomatically = true
    
    container.loadPersistentStores { _, error in
      if let error = error {
        MusculosLogger.logError(error, message: "Failed to load persistent store", category: .coreData)
      }
    }
    
    return container
  }()
  
  public var viewStorage: StorageType {
    return persistentContainer.viewContext
  }
  
  public lazy var writerDerivedStorage: StorageType = {
    let managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    managedObjectContext.parent = persistentContainer.viewContext
    managedObjectContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    return managedObjectContext
  }()
  
  func saveDerivedType(_ derivedStorage: StorageType) async {
    await derivedStorage.performAndSave { }
    await viewStorage.performAndSave { }
  }
  
  func reset() {
    let viewContext = persistentContainer.viewContext
    viewContext.performAndWait {
      viewContext.reset()
      self.deleteAllStoredObjects()
      MusculosLogger.logInfo(message: "CoreDataStack DESTROYED ! 💣", category: .coreData)
    }
  }
}

extension CoreDataStack {
  func deleteSql() {
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("MusculosDataStore.sqlite")

    guard FileManager.default.fileExists(atPath: url.path) else {
      MusculosLogger.logError(MusculosError.notFound, message: "Could not find sqlite db", category: .coreData)
      return
    }

    do {
      try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      MusculosLogger.logError(error, message: "Could not destroy persistent store", category: .coreData)
    }
  }

  func deleteAllStoredObjects() {
    let viewContext = persistentContainer.viewContext
    
    for e in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      let r = NSBatchDeleteRequest(
        fetchRequest: NSFetchRequest(entityName: e.name ?? "")
      )
      _ = try? viewContext.execute(r)
    }
    viewContext.saveIfNeeded()
  }
}

extension CoreDataStack {
  private static var _shared: StorageManagerType?

  static var shared: StorageManagerType {
    if let existingShared = _shared {
      return existingShared
    } else {
      let newShared = CoreDataStack()
      _shared = newShared
      return newShared
    }
  }
  
  static func setOverride(_ override: StorageManagerType) {
    _shared = override
  }

  static func resetOverride() {
    _shared = nil
  }
}

//
//  CoreDataStack.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

class CoreDataStack {
  let persistentContainer: NSPersistentContainer
  let mainContext: NSManagedObjectContext
  let writeOnlyContext: NSManagedObjectContext
  
  init(inMemory: Bool = false) {
    persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
    if inMemory {
      persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
    }
    
    let description = persistentContainer.persistentStoreDescriptions.first
    description?.type = NSSQLiteStoreType
    description?.shouldMigrateStoreAutomatically = true
    description?.shouldInferMappingModelAutomatically = true

    self.persistentContainer.loadPersistentStores { _, error in
      if let error = error {
        MusculosLogger.logError(error: error, message: "Failed to load persistent store", category: .coreData)
      }
    }

    mainContext = persistentContainer.viewContext
    mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    
    writeOnlyContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    writeOnlyContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    writeOnlyContext.parent = mainContext
  }
}

extension CoreDataStack {
  func deleteSql() {
    let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("MusculosDataStore.sqlite")

    guard FileManager.default.fileExists(atPath: url.path) else {
      MusculosLogger.logError(error: MusculosError.notFound, message: "Could not find sqlite db", category: .coreData)
      return
    }

    do {
      try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
    } catch {
      MusculosLogger.logError(error: error, message: "Could not destroy persistent store", category: .coreData)
    }
  }

  func deleteAll() async {
    for e in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      let r = NSBatchDeleteRequest(
        fetchRequest: NSFetchRequest(entityName: e.name ?? "")
      )
      _ = try? mainContext.execute(r)
    }
    await mainContext.performAndSaveIfNeeded()
  }
}

// MARK: - Tests helper

extension CoreDataStack {
  private static var _shared: CoreDataStack?

  static var shared: CoreDataStack {
    if let existingShared = _shared {
      return existingShared
    } else {
      let newShared = CoreDataStack()
      _shared = newShared
      return newShared
    }
  }
  
  static func setOverride(_ override: CoreDataStack) {
    _shared = override
  }

  static func resetOverride() {
    _shared = nil
  }
}

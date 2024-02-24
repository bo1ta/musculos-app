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
  let userPrivateContext: NSManagedObjectContext
  let syncPrivateContext: NSManagedObjectContext
  
  private init() {
    persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
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
    
    userPrivateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    userPrivateContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
    userPrivateContext.parent = mainContext
    
    syncPrivateContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    syncPrivateContext.parent = mainContext
  }
}

// MARK: - Helper methods

extension CoreDataStack {
  static func saveContext(_ context: NSManagedObjectContext) async {
    await context.perform {
      guard context.hasChanges else { return }
      
      do {
        try context.save()
      } catch {
        context.rollback()
        MusculosLogger.logError(error: error, message: "Failed to save context", category: .coreData)
      }
    }
  }
  
  static func asyncSaveContext(_ context: NSManagedObjectContext) {
    context.perform {
      guard context.hasChanges else { return }
      
      do {
        try context.save()
      } catch {
        context.rollback()
        MusculosLogger.logError(error: error, message: "Failed to save context", category: .coreData)
      }
    }
  }
  
  func saveMainContext() async {
    await CoreDataStack.saveContext(mainContext)
  }
  
  func asyncSaveMainContext() {
    CoreDataStack.asyncSaveContext(mainContext)
  }
  
  func fetchAllEntities<T: NSManagedObject>(entityName: String) throws -> [T]? {
    let request = NSFetchRequest<T>(entityName: entityName)
    return try self.mainContext.fetch(request)
  }

  func fetchEntitiesByIds<T: NSManagedObject>(entityName: String, by ids: [Int]) throws -> [T]? {
    let request = NSFetchRequest<T>(entityName: entityName)
    let predicate = NSPredicate(format: "id IN %@", ids)
    request.predicate = predicate
    return try self.mainContext.fetch(request)
  }
}

// MARK: - Clean up -- rarely used

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
      return
    }
  }

  func deleteAll() async {
    for e in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      let r = NSBatchDeleteRequest(
        fetchRequest: NSFetchRequest(entityName: e.name ?? "")
      )
      _ = try? mainContext.execute(r)
    }
    await saveMainContext()
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

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
    let backgroundContext: NSManagedObjectContext

    private init() {
        self.persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
        let description = self.persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType
        description?.shouldMigrateStoreAutomatically = true
        description?.shouldInferMappingModelAutomatically = true

        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                MusculosLogger.log(.error, message: "Failed to load persistent store", error: error, category: .coreData)
            }
        }

        self.mainContext = self.persistentContainer.viewContext
        self.mainContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext.parent = self.mainContext
    }

    func saveMainContext() async throws {
        let context = self.mainContext
        try await context.perform {
            do {
                try context.save()
            } catch {
                MusculosLogger.log(.error, message: "Failed to save main context", error: error, category: .coreData)
                throw error
            }
        }
    }

    func saveBackgroundContext() async throws {
        let context = self.backgroundContext
        try await context.perform {
            do {
                try context.save()
            } catch {
                MusculosLogger.log(.error, message: "Failed to save backgroundContext context", error: error, category: .coreData)
                throw error
            }
        }

    }

    func deleteSql() {
        let url = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0].appendingPathComponent("MusculosDataStore.sqlite")

        guard FileManager.default.fileExists(atPath: url.path) else {
            MusculosLogger.log(.error, message: "Could not find sqlite db", error: MusculosError.notFound, category: .coreData)
            return
        }

        do {
            try self.persistentContainer.persistentStoreCoordinator.destroyPersistentStore(at: url, type: .sqlite)
        } catch {
            MusculosLogger.log(.error, message: "Could not destroy persistent store", error: MusculosError.notFound, category: .coreData)
            return
        }
    }

    func deleteAll() async {
        let container = self.persistentContainer
        for e in container.persistentStoreCoordinator.managedObjectModel.entities {
            let r = NSBatchDeleteRequest(
                fetchRequest: NSFetchRequest(entityName: e.name ?? ""))
            _ = try? container.viewContext.execute(r)
        }

        do {
            try await self.saveMainContext()
        } catch {
            MusculosLogger.log(.error, message: "Could not save after deleting all", category: .coreData)
            return
        }
    }
}

extension CoreDataStack {
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

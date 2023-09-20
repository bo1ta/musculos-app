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
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext

    private init() {
        self.persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
        let description = self.persistentContainer.persistentStoreDescriptions.first
        description?.type = NSSQLiteStoreType

        self.persistentContainer.loadPersistentStores { description, error in
            if let error = error {
                MusculosLogger.log(.error, message: "Failed to load persistent store", error: error, category: .coreData)
            }
        }
        
        self.mainContext = self.persistentContainer.viewContext
        
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext.parent = self.mainContext
    }
    
    func save() throws {
        let context = self.mainContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                MusculosLogger.log(.error, message: "Failed to save", error: error, category: .coreData)
                throw error
            }
        }
    }
}

extension CoreDataStack {
    func fetchAllEntities<T: NSManagedObject>(entityName: String) async throws -> [T]? {
        let request = NSFetchRequest<T>(entityName: entityName)
        return try self.mainContext.fetch(request)
    }
    
    func fetchEntitiesByIds<T: NSManagedObject>(entityName: String, by ids: [Int]) async throws -> [T]? {
        let request = NSFetchRequest<T>(entityName: entityName)
        let predicate = NSPredicate(format: "id IN %@", ids)
        request.predicate = predicate
        return try self.mainContext.fetch(request)
    }
}

extension CoreDataStack {
    private static var _shared: CoreDataStack?
    
    static var shared: CoreDataStack {
        _shared ?? CoreDataStack()
    }
    
    static func setOverride(_ override: CoreDataStack) {
        _shared = override
    }
    
    static func resetOverride() {
        _shared = nil
    }
}

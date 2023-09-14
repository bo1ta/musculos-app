//
//  DataController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    let container: NSPersistentContainer
    
    init(container: NSPersistentContainer) {
        self.container = container
    }
    
    private init() {
        self.container = NSPersistentContainer(name: "MusculosDataStore")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                MusculosLogger.log(.error, message: "Failed to load", error: error, category: .coreData)
            }
        }
    }
    
    func save() throws {
        let context = self.container.viewContext
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

extension DataController {
    func fetchAllEntities<T: NSManagedObject>(entityName: String) async throws -> [T]? {
        try await self.container.performBackgroundTask({ backgroundContext in
            let request = NSFetchRequest<T>(entityName: entityName)
            return try backgroundContext.fetch(request)
        })
    }
    
    func fetchEntitiesByIds<T: NSManagedObject>(entityName: String, by ids: [Int]) async throws -> [T]? {
        try await self.container.performBackgroundTask({ backgroundContext in
            let request = NSFetchRequest<T>(entityName: entityName)
            let predicate = NSPredicate(format: "id IN %@", ids)
            request.predicate = predicate
            return try backgroundContext.fetch(request)
        })
    }
}

extension DataController {
    private static var _shared: DataController?
    
    static var shared: DataController {
        _shared ?? DataController()
    }
    
    static func setOverride(_ override: DataController) {
        _shared = override
    }
    
    static func resetOverride() {
        _shared = nil
    }
}

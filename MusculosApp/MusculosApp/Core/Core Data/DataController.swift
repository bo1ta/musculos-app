//
//  DataController.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 07.07.2023.
//

import Foundation
import CoreData

class DataController: ObservableObject {
    static let shared = DataController()

    let container: NSPersistentContainer
    
    public init() {
        self.container = NSPersistentContainer(name: "MusculosDataStore")
        self.container.loadPersistentStores { description, error in
            if let error = error {
                print("Core data failed to load: \(error)")
            }
        }
    }
    
    func save() throws {
        let context = self.container.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("Core data failed to save: \(error.localizedDescription)")
                throw error
            }
        }
    }
}

extension DataController {
    func fetchMuscles(with ids: [Int]? = nil) async throws -> [MuscleEntity]? {
        try await self.container.performBackgroundTask({ backgroundContext in
            let request = NSFetchRequest<MuscleEntity>(entityName: "MuscleEntity")
            
            if let ids = ids {
                let predicate = NSPredicate(format: "id IN %@", ids)
                request.predicate = predicate
            }
            
            return try backgroundContext.fetch(request)
        })
    }
    
    func fetchEquipment(with ids: [Int]? = nil) async throws -> [EquipmentEntity]? {
        try await self.container.performBackgroundTask({ backgroundContext in
            let request = NSFetchRequest<EquipmentEntity>(entityName: "EquipmentEntity")
            
            if let ids = ids {
                let predicate = NSPredicate(format: "id IN %@", ids)
                request.predicate = predicate
            }
            
            return try backgroundContext.fetch(request)
        })
    }
}

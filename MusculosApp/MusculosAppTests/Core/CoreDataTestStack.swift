//
//  CoreDataTestStack.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import CoreData
import XCTest

struct CoreDataTestStack {
    let persistentContainer: NSPersistentContainer
    let backgroundContext: NSManagedObjectContext
    let mainContext: NSManagedObjectContext
    
    init() {
        self.persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
        let description = self.persistentContainer.persistentStoreDescriptions.first
        description?.type = NSInMemoryStoreType
        
        self.persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                XCTFail("Failed to load persistent store \(error.localizedDescription)")
            }
        }
        
        self.mainContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.mainContext.automaticallyMergesChangesFromParent = true
        self.mainContext.persistentStoreCoordinator = persistentContainer.persistentStoreCoordinator
        
        self.backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        self.backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        self.backgroundContext.parent = self.mainContext
    }
}

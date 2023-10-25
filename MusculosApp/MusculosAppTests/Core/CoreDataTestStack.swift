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
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        description.type = NSSQLiteStoreType

        self.persistentContainer = NSPersistentContainer(name: "MusculosDataStore")
        self.persistentContainer.persistentStoreDescriptions = [description]

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

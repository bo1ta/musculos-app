//
//  MockPersistentContainer.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 14.09.2023.
//

import Foundation
import CoreData

class MockPersistentContainer: NSPersistentContainer {
    lazy var persistentContainer: NSPersistentContainer = {
        let description = NSPersistentStoreDescription()
        description.url = URL(fileURLWithPath: "/dev/null")
        let container = NSPersistentContainer(name: "MockPersistentContainer")
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("Unable to load persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()
}

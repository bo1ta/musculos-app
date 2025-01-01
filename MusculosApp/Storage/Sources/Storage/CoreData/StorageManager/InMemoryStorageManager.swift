//
//  InMemoryStorageManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import CoreData
import Foundation
import Utility

public class InMemoryStorageManager: StorageManager, @unchecked Sendable {
  override public var coalesceSaveInterval: Double {
    0.0
  }

  private var _persistentContainer: NSPersistentContainer?

  override public init() { }

  override public var persistentContainer: NSPersistentContainer {
    get {
      if let persistentContainer = _persistentContainer {
        return persistentContainer
      } else {
        guard
          let modelURL = Bundle.module.url(forResource: "MusculosDataModel", withExtension: ".momd"),
          let model = NSManagedObjectModel(contentsOf: modelURL)
        else {
          fatalError("Could not load Core Data model")
        }

        let description = NSPersistentStoreDescription(url: URL(filePath: "/dev/null"))
        let container = NSPersistentContainer(name: "MusculosDataStore", managedObjectModel: model)
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
          if let error {
            Logger.error(error, message: "Failed to load persistent store")
          }
        }
        _persistentContainer = container

        return container
      }
    }

    set { }
  }

  override public func performWrite(_ writeClosure: @escaping WriteStorageClosure) async throws {
    try await super.performWrite(writeClosure)

    await saveChanges()
  }

  override public func deleteAllStoredObjects() {
    let viewContext = persistentContainer.viewContext

    for entity in persistentContainer.persistentStoreCoordinator.managedObjectModel.entities {
      guard let entityName = entity.name else {
        continue
      }

      let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)

      do {
        let objects = try viewContext.fetch(fetchRequest)
        for object in objects {
          viewContext.delete(object)
        }
        viewContext.saveIfNeeded()
      } catch {
        print("Failed to fetch objects for entity \(entityName): \(error)")
      }
    }
  }
}

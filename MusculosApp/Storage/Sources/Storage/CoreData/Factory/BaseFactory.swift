//
//  BaseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Fakery
import Queue

public class BaseFactory: @unchecked Sendable {
  let faker = Faker()
  let backgroundWorker = AsyncQueue()

  var dataStore: CoreDataStore {
    return StorageContainer.shared.coreDataStore()
  }

  private var viewStorage: StorageType {
    StorageContainer.shared.storageManager().viewStorage
  }

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) {
    viewStorage.performAndWait {
      let object = viewStorage.insertNewObject(ofType: type)
      object.populateEntityFrom(model, using: viewStorage)
      viewStorage.saveIfNeeded()
    }
  }
}

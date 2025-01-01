//
//  BaseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Fakery

public class BaseFactory: @unchecked Sendable {
  let faker = Faker()

  var storage: StorageType {
    StorageContainer.shared.storageManager().writerDerivedStorage
  }

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) {
    storage.performAndWait {
      let entity = storage.insertNewObject(ofType: type)
      entity.populateEntityFrom(model, using: storage)
      storage.saveIfNeeded()
    }
  }
}

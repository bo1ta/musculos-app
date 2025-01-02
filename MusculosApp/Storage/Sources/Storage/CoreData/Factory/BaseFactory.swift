//
//  BaseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Fakery

protocol BaseFactory: Sendable {
  associatedtype ReadOnlyType

  var faker: Faker { get }
  var storage: StorageType { get }
  var isPersistent: Bool { get set }

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type)
  func create() -> ReadOnlyType
}

extension BaseFactory {
  var faker: Faker { Faker() }

  var storage: StorageType { StorageContainer.shared.storageManager().writerDerivedStorage }

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type) {
    guard isPersistent else {
      return
    }

    storage.performAndWait {
      let entity = storage.insertNewObject(ofType: type)
      entity.populateEntityFrom(model, using: storage)
      storage.saveIfNeeded()
    }
  }
}

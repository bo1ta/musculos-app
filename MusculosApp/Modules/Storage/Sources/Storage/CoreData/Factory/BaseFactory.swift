//
//  BaseFactory.swift
//  Storage
//
//  Created by Solomon Alexandru on 18.12.2024.
//

import Fakery

// MARK: - BaseFactory

protocol BaseFactory: Sendable {
  associatedtype ReadOnlyType

  init()

  var faker: Faker { get }
  var storage: StorageType { get }
  var isPersistent: Bool { get set }

  static func make(_ configure: (Self) -> Void) -> ReadOnlyType

  func syncObject<T: EntitySyncable>(_ model: T.ModelType, of type: T.Type)
  func create() -> ReadOnlyType
}

extension BaseFactory {
  var faker: Faker { Faker() }

  var storage: StorageType { StorageContainer.shared.storageManager().viewStorage }

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

  static func make(_ configure: (Self) -> Void) -> ReadOnlyType {
    let factory = Self()
    configure(factory)
    return factory.create()
  }
}

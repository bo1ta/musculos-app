//
//  EntitySyncable.swift
//
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import CoreData
import Foundation
import Utility

public protocol EntitySyncable: Object {
  associatedtype ModelType: IdentifiableEntity

  func populateEntityFrom(_ model: ModelType, using storage: StorageType)
  func updateEntityFrom(_ model: ModelType, using storage: StorageType)
}

extension EntitySyncable {
  static func findOrCreate(from model: ModelType, using storage: StorageType) -> Self {
    if let firstObject = storage.firstObject(of: Self.self, matching: model.matchingPredicate()) {
      return firstObject
    } else {
      let newObject = storage.insertNewObject(ofType: Self.self)
      newObject.populateEntityFrom(model, using: storage)
      return newObject
    }
  }
}

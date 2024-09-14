//
//  EntityPopulatable.swift
//
//
//  Created by Solomon Alexandru on 14.09.2024.
//

import CoreData
import Foundation

/// Helper protocol that handles the Core Data data popuulation, by mirroring a `SyncableObject`
///
public protocol EntityPopulatable {
  associatedtype ModelType: Decodable

  /// Populate the entity, from
  func populateEntity(from model: ModelType, using storage: StorageType) -> NSManagedObject
  func updateEntity(from model: ModelType, using storage: StorageType) -> NSManagedObject
}

extension EntityPopulatable where Self: NSManagedObject {
  func defaultPopulateEntity(from model: ModelType, using storage: StorageType) -> NSManagedObject {
    let mirror = Mirror(reflecting: model)

    for child in mirror.children {
      guard let label = child.label else { continue }

      if let property = entity.attributesByName[label] {
        try self.setValue(child.value, forKey: label)
      }
    }

    return self
  }

  func populateEntity(from model: ModelType, using storage: StorageType) -> NSManagedObject {
    return defaultPopulateEntity(from: model, using: storage)
  }

  func updateEntity(from model: ModelType, using storage: StorageType) -> NSManagedObject {
    return defaultPopulateEntity(from: model, using: storage)
  }
}

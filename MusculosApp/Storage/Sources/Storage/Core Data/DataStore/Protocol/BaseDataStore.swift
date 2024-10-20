//
//  DataStoreBase.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Foundation
import Factory

/// Helper protocol for Core Data store operations
///
public protocol BaseDataStore {
  /// Represents the Core Data storage manager
  ///
  var storageManager: StorageManagerType { get }
}

extension BaseDataStore {
  public var storageManager: StorageManagerType {
    return StorageContainer.shared.storageManager()
  }

  /// Handle the object synchronization
  /// If the object exists, update it
  /// If no object exists, create it
  ///
  public func handleObjectSync<SyncableEntity: EntitySyncable & Object>(
    remoteObject: SyncableEntity.ModelType,
    localObjectType: SyncableEntity.Type
  ) async throws {
    return try await storageManager.performWrite { storage in
      if let existingEntity = storage.firstObject(of: SyncableEntity.self, matching: remoteObject.matchingPredicate()) {
        try existingEntity.updateEntityFrom(remoteObject, using: storage)
      } else {
        let newEntity = storage.insertNewObject(ofType: SyncableEntity.self)
        try newEntity.populateEntityFrom(remoteObject, using: storage)
      }
    }
  }

  /// Handle the objects insertion
  /// Existing objects are skipped
  ///
  public func importToStorage<SyncableEntity: EntitySyncable & Object>(
    remoteObjects: [SyncableEntity.ModelType],
    localObjectType: SyncableEntity.Type
  ) async throws {
    return try await storageManager.performWrite { storage in
      let existingIdentifiers = storage.fetchUniquePropertyValues(
        of: SyncableEntity.self,
        property: SyncableEntity.ModelType.identifierKey
      ) ?? Set<UUID>()

      remoteObjects
        .filter { !existingIdentifiers.contains($0.identifierValue) }
        .forEach { object in
          let entity = storage.insertNewObject(ofType: SyncableEntity.self)
          entity.populateEntityFrom(object, using: storage)
        }
    }
  }
}

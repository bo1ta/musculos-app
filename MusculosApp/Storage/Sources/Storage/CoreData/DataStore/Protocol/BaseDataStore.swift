//
//  BaseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Factory
import Foundation

// MARK: - BaseDataStore

/// Helper protocol for Core Data store operations
///
public protocol BaseDataStore {
  /// Represents the Core Data storage manager
  ///
  var storageManager: StorageManagerType { get }
}

extension BaseDataStore {
  public var storageManager: StorageManagerType {
    StorageContainer.shared.storageManager()
  }

  /// Handle the object synchronization
  /// If the object exists, update it
  /// If no object exists, create it
  ///
  public func handleObjectSync<SyncableEntity: EntitySyncable & Object>(
    remoteObject: SyncableEntity.ModelType,
    localObjectType _: SyncableEntity.Type)
    async throws
  {
    try await storageManager.performWrite { storage in
      if let existingEntity = storage.firstObject(of: SyncableEntity.self, matching: remoteObject.matchingPredicate()) {
        existingEntity.updateEntityFrom(remoteObject, using: storage)
      } else {
        let newEntity = storage.insertNewObject(ofType: SyncableEntity.self)
        newEntity.populateEntityFrom(remoteObject, using: storage)
      }
    }
  }

  /// Handle the objects insertion
  /// Existing objects are skipped
  ///
  public func importToStorage<SyncableEntity: EntitySyncable & Object>(
    models: [SyncableEntity.ModelType],
    localObjectType _: SyncableEntity.Type)
    async throws
  {
    try await storageManager.performWrite { storage in
      let existingIdentifiers = storage.fetchUniquePropertyValues(
        of: SyncableEntity.self,
        property: SyncableEntity.ModelType.identifierKey)

      models
        .filter { !existingIdentifiers.contains($0.identifierValue) }
        .forEach { object in
          let entity = storage.insertNewObject(ofType: SyncableEntity.self)
          entity.populateEntityFrom(object, using: storage)
        }
    }
  }
}

//
//  SyncManager.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.02.2025.
//

import Factory
import Foundation
import Storage
import Utility

// MARK: - SyncManagerProtocol

/// A protocol defining the synchronization behaviour for entities
///
protocol SyncManagerProtocol: Sendable {
  /// The time interval threshold to determine if local storage should be used
  ///
  var syncThreshold: TimeInterval { get }

  /// Determines whether local storage should be used for a given entity type
  /// - Parameter entity: The entity type to check
  /// - Returns: A boolean indicating whether local storage should be used
  ///
  func shouldUseLocalStorage<T: EntitySyncable>(for entity: T.Type) -> Bool

  /// Retrieves the last synchronization date for a given entity type
  /// - Parameter type: The entity type to check
  /// - Returns: The last sync date or nil if not available
  ///
  func getSyncDateForEntity<T: EntitySyncable>(_ type: T.Type) -> Date?

  /// Updates the last synchronization date for a given entity type
  /// - Parameters:
  ///   - type: The entity type to update
  ///   - date: The date of the last synchronization
  ///
  func setSyncDateForEntity<T: EntitySyncable>(_ type: T.Type, date: Date)

  /// Inserts a model into local storage asynchronously
  /// - Parameters:
  ///   - model: The model instance to insert
  ///   - type: The entity type associated with the model
  /// - Throws: An error if the operation fails
  ///
  func insertToStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type) async throws

  /// Synchronizes multiple models into local storage
  /// - Parameters:
  ///   - models: The models to sync.
  ///   - type: The entity type associated with the models
  ///
  func syncStorage<T: EntitySyncable>(_ models: [T.ModelType], ofType type: T.Type)

  /// Synchronizes a single model into local storage
  /// - Parameters:
  ///   - model: The model to sync.
  ///   - type: The entity type associated with the model
  ///
  func syncStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type)

  /// Waits for all background tasks to complete
  ///
  func waitForAllBackgroundTasks() async
}

// MARK: - SyncManager

struct SyncManager: SyncManagerProtocol, @unchecked Sendable {
  @Injected(\StorageContainer.storageManager) private var storageManager
  @Injected(\.backgroundWorker) private var backgroundWorker: BackgroundWorker

  /// The time interval threshold to determine if local storage should be used
  ///
  let syncThreshold: TimeInterval

  /// Initializes a `SyncManager` with an optional sync threshold
  /// - Parameter syncThreshold: The time interval threshold (default is one hour)
  ///
  init(syncThreshold: TimeInterval = .oneHour) {
    self.syncThreshold = syncThreshold
  }

  func insertToStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type) async throws {
    try await storageManager.importEntity(model, of: type)
  }

  func syncStorage<T: EntitySyncable>(_ models: [T.ModelType], ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await storageManager.importEntities(models, of: type)
      setSyncDateForEntity(type, date: Date())
    }
  }

  func syncStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await storageManager.importEntity(model, of: type)
      // sync date not updated for single models since it doesn't represent a "full update"
    }
  }

  func getSyncDateForEntity(_ type: (some EntitySyncable).Type) -> Date? {
    UserDefaults.standard.object(forKey: getUserDefaultsKey(type.entityName)) as? Date
  }

  func setSyncDateForEntity(_ type: (some EntitySyncable).Type, date: Date) {
    UserDefaults.standard.set(date, forKey: getUserDefaultsKey(type.entityName))
  }

  /// Generates a unique key for storing sync date in UserDefaults.
  /// - Parameter entityName: The name of the entity.
  /// - Returns: A string key used in UserDefaults.
  ///
  private func getUserDefaultsKey(_ entityName: String) -> String {
    UserDefaultsKey.syncDate(for: entityName)
  }

  func shouldUseLocalStorage(for entity: (some EntitySyncable).Type) -> Bool {
    guard let lastUpdated = getSyncDateForEntity(entity) else {
      return false
    }
    return Date().timeIntervalSince(lastUpdated) < syncThreshold
  }

  func waitForAllBackgroundTasks() async {
    await backgroundWorker.waitForAll()
  }
}

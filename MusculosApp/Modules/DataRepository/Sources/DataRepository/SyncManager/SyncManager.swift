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

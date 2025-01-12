//
//  BaseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation
import NetworkClient
import Storage
import Utility

// MARK: - BaseRepository

protocol BaseRepository: Sendable {
  var localStorageUpdateThreshold: TimeInterval { get }

  func syncStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type)
  func syncStorage<T: EntitySyncable>(_ models: [T.ModelType], ofType type: T.Type)
  func getSyncDateForEntity<T: EntitySyncable>(_ entity: T.Type) -> Date?
  func setSyncDateForEntity<T: EntitySyncable>(_ entity: T.Type, date: Date)
  func shouldUseLocalStorageForEntity<T: EntitySyncable>(_ entity: T.Type) -> Bool
}

extension BaseRepository {
  var localStorageUpdateThreshold: TimeInterval { .oneHour }

  var currentUserID: UUID? {
    NetworkContainer.shared.userManager().currentUserID
  }

  var coreDataStore: CoreDataStore {
    StorageContainer.shared.coreDataStore()
  }

  var isConnectedToInternet: Bool {
    NetworkContainer.shared.networkMonitor().isConnected
  }

  var backgroundWorker: BackgroundWorker {
    DataRepositoryContainer.shared.backgroundWorker()
  }

  func syncStorage<T: EntitySyncable>(_ models: [T.ModelType], ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await coreDataStore.importModels(models, of: type)
      await setSyncDateForEntity(type, date: Date())
    }
  }

  func syncStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await coreDataStore.importModel(model, of: type)
      // sync date not updated for single models since it doesn't represent a "full update"
    }
  }

  func getSyncDateForEntity<T: EntitySyncable>(_ entity: T.Type) -> Date? {
    UserDefaults.standard.object(forKey: getUserDefaultsKey(entity.entityName)) as? Date
  }

  func setSyncDateForEntity<T: EntitySyncable>(_ entity: T.Type, date: Date) {
    UserDefaults.standard.set(date, forKey: getUserDefaultsKey(entity.entityName))
  }

  private func getUserDefaultsKey(_ entityName: String) -> String {
    UserDefaultsKey.syncDate(for: entityName)
  }

  func shouldUseLocalStorageForEntity(_ entity: (some EntitySyncable).Type) -> Bool {
    guard let lastUpdated = getSyncDateForEntity(entity) else {
      return false
    }
    return Date().timeIntervalSince(lastUpdated) < localStorageUpdateThreshold
  }
}

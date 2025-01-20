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
  var dataStore: CoreDataStore { get }
}

// MARK: Default

extension BaseRepository {
  var localStorageUpdateThreshold: TimeInterval { .oneHour }
}

// MARK: Common dependencies

extension BaseRepository {
  var currentUserID: UUID? {
    NetworkContainer.shared.userManager().currentUserID
  }

  var isConnectedToInternet: Bool {
    NetworkContainer.shared.networkMonitor().isConnected
  }

  var backgroundWorker: BackgroundWorker {
    DataRepositoryContainer.shared.backgroundWorker()
  }
}

// MARK: Synchronization

extension BaseRepository {
  func syncStorage<T: EntitySyncable>(_ models: [T.ModelType], ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await dataStore.importModels(models, of: type)
      setSyncDateForEntity(type, date: Date())
    }
  }

  func syncStorage<T: EntitySyncable>(_ model: T.ModelType, ofType type: T.Type) {
    backgroundWorker.queueOperation {
      try await dataStore.importModel(model, of: type)
      // sync date not updated for single models since it doesn't represent a "full update"
    }
  }

  func getSyncDateForEntity(_ entity: (some EntitySyncable).Type) -> Date? {
    UserDefaults.standard.object(forKey: getUserDefaultsKey(entity.entityName)) as? Date
  }

  func setSyncDateForEntity(_ entity: (some EntitySyncable).Type, date: Date) {
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

// MARK: Fetch functionalities

extension BaseRepository {
  func fetchAndSync<T: EntitySyncable>(
    remoteTask: @escaping @Sendable () async throws -> [T.ModelType],
    syncType type: T.Type)
    async throws -> [T.ModelType]
  {
    let results = try await remoteTask()
    syncStorage(results, ofType: type)
    return results
  }

  func fetchAndSync<T: EntitySyncable>(
    remoteTask: @escaping @Sendable () async throws -> T.ModelType,
    syncType type: T.Type)
    async throws -> T.ModelType
  {
    let result = try await remoteTask()
    syncStorage(result, ofType: type)
    return result
  }

  func fetch<T: EntitySyncable>(
    forType type: T.Type,
    localTask: @escaping @Sendable () async -> T.ModelType?,
    remoteTask: @escaping @Sendable () async throws -> T.ModelType?)
    async throws -> T.ModelType?
  {
    if shouldUseLocalStorageForEntity(type) || !isConnectedToInternet, let localResult = await localTask() {
      return localResult
    }

    if let results = try await remoteTask() {
      syncStorage(results, ofType: type)
      return results
    }
    return nil
  }

  func fetch<T: EntitySyncable>(
    forType type: T.Type,
    localTask: @escaping @Sendable () async -> [T.ModelType],
    remoteTask: @escaping @Sendable () async throws -> [T.ModelType])
    async throws -> [T.ModelType]
  {
    var localResults: [T.ModelType] = []
    if shouldUseLocalStorageForEntity(type) || !isConnectedToInternet {
      localResults = await localTask()
    }
    guard localResults.isEmpty else {
      return localResults
    }

    let results = try await remoteTask()
    syncStorage(results, ofType: type)
    return results
  }

  func makeAsyncStream<T>(
    localFetch: @escaping @Sendable () async -> T,
    remoteFetch: @escaping @Sendable () async throws -> T)
    -> AsyncStream<Result<T, Error>>
  {
    AsyncStream { continuation in
      let task = Task {
        do {
          try Task.checkCancellation()

          let localResults = await localFetch()
          continuation.yield(.success(localResults))

          try Task.checkCancellation()

          let remoteResults = try await remoteFetch()
          continuation.yield(.success(remoteResults))

          continuation.finish()
        } catch {
          continuation.yield(.failure(error))
        }
        continuation.finish()
      }

      continuation.onTermination = { _ in
        task.cancel()
      }
    }
  }
}

// MARK: Update functionalities

extension BaseRepository {
  func update(
    localTask: @escaping @Sendable () async throws -> Void,
    remoteTask: @escaping @Sendable () async throws -> Void)
    async throws
  {
    try await localTask()
    backgroundWorker.queueOperation {
      try await remoteTask()
    }
  }
}

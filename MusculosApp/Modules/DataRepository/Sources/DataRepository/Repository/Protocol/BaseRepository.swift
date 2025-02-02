//
//  BaseRepository.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Factory
import Foundation
import NetworkClient
import Storage
import Utility

// MARK: - BaseRepository

/// Protocol defining the base requirements for a repository
///
protocol BaseRepository: Sendable {

  /// The sync manager responsible for handling data synchronization between local and remote storage
  ///
  var syncManager: SyncManagerProtocol { get }

  /// The network monitor responsible for tracking the device's internet connectivity status
  ///
  var networkMonitor: NetworkMonitorProtocol { get }

  /// The user sesion manager responsible for managing the current user's session and ID
  ///
  var userManager: UserSessionManagerProtocol { get }
}

// MARK: - Default Dependencies

extension BaseRepository {

  /// The container shared instance of `NetworkMonitor`
  ///
  var networkMonitor: NetworkMonitorProtocol {
    NetworkContainer.shared.networkMonitor()
  }

  /// The container shared instance of the `UserManager`
  ///
  var userManager: UserSessionManagerProtocol {
    NetworkContainer.shared.userManager()
  }

  /// The current user ID, if exists
  ///
  var currentUserID: UUID? {
    userManager.currentUserID
  }

  /// Ensures that a current user ID is available and returns it.
  /// - Throws: `MusculosError.unexpectedNil` if no user ID is found
  /// - Returns: The current user's ID
  ///
  func requireCurrentUser() throws -> UUID {
    guard let userID = currentUserID else {
      throw MusculosError.unexpectedNil
    }
    return userID
  }

  /// Indicates whether the device is currently connected to the internet
  ///
  var isConnectedToInternet: Bool {
    networkMonitor.isConnected
  }
}

// MARK: Repository Operations

extension BaseRepository {

  /// Fetches data of a specific type, first attempting to retrieve it from local storage,
  /// and falling back to remote storage if necessary.
  /// - Parameters:
  ///   - type: The type of the entity to fetch.
  ///   - localTask: A closure that fetches the data from local storage.
  ///   - remoteTask: A closure that fetches the data from remote storage.
  /// - Returns: The fetched data of the specified type.
  /// - Throws: An error if the remote fetch fails.
  ///
  func fetch<T: EntitySyncable>(
    forType type: T.Type,
    localTask: @escaping @Sendable () async -> T.ModelType?,
    remoteTask: @escaping @Sendable () async throws -> T.ModelType)
    async throws -> T.ModelType
  {
    if shouldUseLocalStorage(forType: type), let localResult = await localTask() {
      return localResult
    }

    let remoteResult = try await remoteTask()
    syncManager.syncStorage(remoteResult, ofType: type)
    return remoteResult
  }

  /// Fetches an array of data of a specific type, first attempting to retrieve it from local storage,
  /// and falling back to remote storage if necessary.
  /// - Parameters:
  ///   - type: The type of the entity to fetch.
  ///   - localTask: A closure that fetches the data from local storage.
  ///   - remoteTask: A closure that fetches the data from remote storage.
  /// - Returns: An array of the fetched data of the specified type.
  /// - Throws: An error if the remote fetch fails.
  ///
  func fetch<T: EntitySyncable>(
    forType type: T.Type,
    localTask: @escaping @Sendable () async -> [T.ModelType],
    remoteTask: @escaping @Sendable () async throws -> [T.ModelType])
    async throws -> [T.ModelType]
  {
    let localResults = await localTask()
    if shouldUseLocalStorage(forType: type), !localResults.isEmpty {
      return localResults
    }

    let remoteResult = try await remoteTask()
    syncManager.syncStorage(remoteResult, ofType: type)
    return remoteResult
  }

  /// Determines whether local storage should be used for a given entity type
  ///
  private func shouldUseLocalStorage(forType type: (some EntitySyncable).Type) -> Bool {
    syncManager.shouldUseLocalStorage(for: type) || !networkMonitor.isConnected
  }

  /// Creates an `AsyncStream` that yields results from both local and remote fetches, in order
  /// - Parameters:
  ///   - localFetch: A closure that fetches data from local storage.
  ///   - remoteFetch: A closure that fetches data from remote storage.
  /// - Returns: An `AsyncStream` that yields `Result<T, Error>` values.
  ///
  func makeAsyncStream<T: EntitySyncable>(
    ofType type: T.Type,
    localFetch: @escaping @Sendable () async -> [T.ModelType],
    remoteFetch: @escaping @Sendable () async throws -> [T.ModelType])
    -> AsyncStream<Result<[T.ModelType], Error>>
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

          syncManager.syncStorage(remoteResults, ofType: type)

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

  /// Updates data by first performing a local task and then queuing a remote task for execution
  /// - Parameters:
  ///   - localTask: A closure that performs the local update.
  ///   - remoteTask: A closure that performs the remote update.
  /// - Throws: An error if either the local or remote task fails.
  ///
  func update(
    localTask: @escaping @Sendable () async throws -> Void,
    remoteTask: @escaping @Sendable () async throws -> Void)
    async throws
  {
    try await localTask()

    // queue the remote task to be executed in the background
    Container.shared.backgroundWorker().queueOperation {
      try await remoteTask()
    }
  }
}

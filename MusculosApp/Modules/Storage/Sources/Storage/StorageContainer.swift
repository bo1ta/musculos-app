//
//  StorageContainer.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.09.2024.
//

import Factory

// MARK: - StorageContainer

public final class StorageContainer: SharedContainer {
  public static let shared = StorageContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

extension StorageContainer {
  public var exerciseDataStore: Factory<ExerciseDataStoreProtocol> {
    self { ExerciseDataStore() }
  }

  public var exerciseSessionDataStore: Factory<ExerciseSessionDataStoreProtocol> {
    self { ExerciseSessionDataStore() }
  }

  public var goalDataStore: Factory<GoalDataStoreProtocol> {
    self { GoalDataStore() }
  }

  public var userDataStore: Factory<UserDataStoreProtocol> {
    self { UserDataStore() }
  }

  public var workoutDataStore: Factory<WorkoutDataStoreProtocol> {
    self { WorkoutDataStore() }
  }

  public var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { InMemoryStorageManager() }
      .onPreview { InMemoryStorageManager() }
      .singleton
  }
}

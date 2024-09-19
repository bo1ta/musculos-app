//
//  StorageContainer.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.09.2024.
//

import Factory

public final class StorageContainer: SharedContainer {
  nonisolated(unsafe) public static let shared = StorageContainer()

  public var manager = ContainerManager()
}

extension StorageContainer {
  public var exerciseDataStore: Factory<ExerciseDataStoreProtocol> {
    self { ExerciseDataStore() }
  }

  public var userDataStore: Factory<UserDataStoreProtocol> {
    self { UserDataStore() }
  }

  public var exerciseSessionDataStore: Factory<ExerciseSessionDataStoreProtocol> {
    self { ExerciseSessionDataStore() }
  }

  public var goalDataStore: Factory<GoalDataStoreProtocol> {
    self { GoalDataStore() }
  }

  public var workoutDataStore: Factory<WorkoutDataStoreProtocol> {
    self { WorkoutDataStore() }
  }

  public var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { InMemoryStorageManager() }
      .singleton
  }

  public var dataController: Factory<DataController> {
    self { DataController() }
      .cached
  }

  public var userManager: Factory<UserSessionManagerProtocol> {
    self { UserSessionManager() }
      .cached
  }
}

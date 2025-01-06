//
//  StorageContainer.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.09.2024.
//

import Factory
import UIKit
import Utility

// MARK: - StorageContainer

public final class StorageContainer: SharedContainer {
  public static let shared = StorageContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

extension StorageContainer {
  public var coreDataStore: Factory<CoreDataStore> {
    self { CoreDataStore() }
      .shared
  }

  public var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { InMemoryStorageManager() }
      .onPreview { InMemoryStorageManager() }
      .singleton
  }
}

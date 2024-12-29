//
//  StorageContainer.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.09.2024.
//

import Factory
import UIKit
import Utility

public final class StorageContainer: SharedContainer {
  public static let shared = StorageContainer()

  public nonisolated(unsafe) var manager = ContainerManager()
}

public extension StorageContainer {
  var coreDataStore: Factory<CoreDataStore> {
    self { CoreDataStore() }
      .shared
  }

  var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { InMemoryStorageManager() }
      .onPreview { InMemoryStorageManager() }
      .singleton
  }

  var userManager: Factory<UserSessionManagerProtocol> {
    self { UserSessionManager() }
      .cached
  }
}

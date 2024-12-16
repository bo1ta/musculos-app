//
//  StorageContainer.swift
//  Storage
//
//  Created by Solomon Alexandru on 16.09.2024.
//

import Factory
import Utility
import UIKit

public final class StorageContainer: SharedContainer {
  nonisolated(unsafe) public static let shared = StorageContainer()

  public var manager = ContainerManager()
}

extension StorageContainer {
  public var coreDataStore: Factory<CoreDataStore> {
    self { CoreDataStore() }
      .shared
  }

  public var storageManager: Factory<StorageManagerType> {
    self { StorageManager() }
      .onTest { InMemoryStorageManager() }
      .singleton
  }

  public var userManager: Factory<UserSessionManagerProtocol> {
    self { UserSessionManager() }
      .cached
  }
}

//
//  DataStoreBase.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Foundation
import Factory

/// Helper protocol for Core Data store operations
///
protocol DataStoreBase {
  /// Represents the Core Data storage manager
  ///
  var storageManager: StorageManagerType { get }
}

extension DataStoreBase {
  var storageManager: StorageManagerType {
    return StorageContainer.shared.storageManager()
  }
}

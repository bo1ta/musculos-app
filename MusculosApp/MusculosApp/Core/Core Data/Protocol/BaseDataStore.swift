//
//  BaseDataStore.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.03.2024.
//

import Foundation
import Factory

/// Helper protocol for Core Data store operations
///
protocol BaseDataStore {
  /// Represents the Core Data storage manager
  ///
  var storageManager: StorageManagerType { get }
}

extension BaseDataStore {
  var storageManager: StorageManagerType {
    return Container.shared.storageManager()
  }
}

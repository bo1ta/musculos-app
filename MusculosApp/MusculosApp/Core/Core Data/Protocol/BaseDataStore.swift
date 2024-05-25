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
  
  /// Represents a private queue, suited for background operations.
  ///
  var writerDerivedStorage: StorageType { get }
  
  /// Represents main thread, suited for UI operations.
  ///
  var viewStorage: StorageType { get }
}

extension BaseDataStore {
  var writerDerivedStorage: StorageType {
    let storageManager = Container.shared.storageManager()
    return storageManager.writerDerivedStorage
  }
  
  var viewStorage: StorageType {
    let storageManager = Container.shared.storageManager()
    return storageManager.viewStorage
  }
}

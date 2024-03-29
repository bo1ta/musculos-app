//
//  StorageManagerType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation

protocol StorageManagerType {
  
  /// Returns the `Storage` associated to the main thread
  ///
  var viewStorage: StorageType { get }
  
  /// Returns a shared derived instance for write operations
  ///
  var writerDerivedStorage: StorageType { get }
  
  /// Save a derived context created with w`writerDerivedStorage`
  /// NOTE: Never use viewStorage
  ///
  func saveDerivedType(_ derivedStorage: StorageType) async
  
  /// Convenience method for clearing the data store
  ///
  func reset()
}

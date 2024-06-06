//
//  StorageManagerType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import CoreData

protocol StorageManagerType {
  
  /// Returns the `Storage` associated to the main thread
  ///
  var viewStorage: StorageType { get }
    
  /// Returns a shared derived instance for write operations
  ///
  var writerDerivedStorage: StorageType { get }
  
  /// Save core data changes
  ///
  func saveChanges() async
  
  /// Save core data changes with completion
  ///
  func saveChanges(completion: @escaping () -> Void)
  
  /// Perform a write operation. Uses `writerDerivedStorage`
  ///
  func performWriteOperation<T>(_ task: @escaping (StorageType) throws -> T) async throws -> T
  
  /// Perform a read operation. Uses `viewStorage`
  ///
  func performReadOperation<T>(_ task: @escaping (StorageType) -> T) async -> T
  
  /// Convenience method for clearing the data store
  ///
  func reset()
}

//
//  StorageManagerType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import CoreData
import Foundation

public protocol StorageManagerType: StorageOperations {
  /// Returns the `Storage` associated to the main thread
  ///
  var viewStorage: StorageType { get }

  /// Returns a shared derived instance for write operations
  ///
  var writerDerivedStorage: StorageType { get }

  /// The time interval to save, after the last write
  ///
  var coalesceSaveInterval: Double { get }

  /// Save core data changes
  ///
  func saveChanges() async

  /// Save core data changes with completion
  ///
  func saveChanges(completion: @escaping () -> Void)

  /// Convenience method for clearing the data store
  ///
  func reset()
}

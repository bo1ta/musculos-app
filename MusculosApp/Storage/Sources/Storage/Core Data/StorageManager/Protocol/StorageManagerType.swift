//
//  StorageManagerType.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 25.03.2024.
//

import Foundation
import CoreData

public typealias ReadStorageClosure<ResultType> = (StorageType) -> ResultType
public typealias WriteStorageClosure = (StorageType) throws -> Void

public protocol StorageManagerType {

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
  
  /// Perform a write operation. Uses `writerDerivedStorage`
  ///
  func performWrite(_ writeClosure: @escaping WriteStorageClosure) async throws
  
  /// Perform a read operation. Uses `viewStorage`
  ///
  func performRead<ResultType>(_ readClosure: @escaping ReadStorageClosure<ResultType>) async -> ResultType
  
  /// Convenience method for clearing the data store
  ///
  func reset()
}

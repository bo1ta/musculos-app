//
//  CoreDataWriteOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
import CoreData

final class CoreDataWriteOperation: Operation, @unchecked Sendable {
  let task: (StorageType) throws -> Void
  let storage: StorageType
  let continuation: CheckedContinuation<Void, Error>
  
  init(task: @escaping (StorageType) throws -> Void, storage: StorageType, continuation: CheckedContinuation<Void, Error>) {
    self.task = task
    self.storage = storage
    self.continuation = continuation
  }
  
  override func main() {
    storage.performSync {
      do {
        try self.task(self.storage)
        self.continuation.resume(returning: ())
        
        self.notifyChanges()
      } catch {
        self.continuation.resume(throwing: error)
      }
    }
  }
  
  /// Notify changes to the context to trigger the `onChange` notification
  ///
  private func notifyChanges() {
    guard let context = storage as? NSManagedObjectContext else { return }
    context.processPendingChanges()
  }
}

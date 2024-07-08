//
//  CoreDataWriteOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
import CoreData

final class CoreDataWriteOperation: AsyncOperation, @unchecked Sendable {
  let storage: StorageType
  let closure: CoreDataWriteClosure
  let continuation: CheckedContinuation<Void, Error>
  
  init(
    storage: StorageType,
    closure: @escaping CoreDataWriteClosure,
    continuation: CheckedContinuation<Void, Error>
  ) {
    self.storage = storage
    self.closure = closure
    self.continuation = continuation
  }
  
  override func main() {
    storage.performSync {
      do {
        try self.closure(self.storage)
        self.notifyChanges()
        self.continuation.resume(returning: ())
      } catch {
        MusculosLogger.logError(error, message: "Error on Core Data writing", category: .coreData)
        self.continuation.resume(throwing: error)
      }
      
      self.state = .finished
    }
  }
  
  /// Notify changes to the context to trigger the `onChange` notification
  ///
  private func notifyChanges() {
    guard let context = storage as? NSManagedObjectContext else { return }
    context.processPendingChanges()
  }
}

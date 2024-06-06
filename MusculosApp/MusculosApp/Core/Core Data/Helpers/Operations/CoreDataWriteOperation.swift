//
//  CoreDataWriteOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation
import CoreData

final class CoreDataWriteOperation<T>: Operation {
  let task: (StorageType) throws -> T
  let storage: StorageType
  let continuation: CheckedContinuation<T, Error>
  
  init(task: @escaping (StorageType) throws -> T, storage: StorageType, continuation: CheckedContinuation<T, Error>) {
    self.task = task
    self.storage = storage
    self.continuation = continuation
  }
  
  override func main() {
    storage.performSync {
      do {
        let result = try self.task(self.storage)
        self.continuation.resume(returning: result)
        
        self.notifyChanges()
      } catch {
        self.continuation.resume(throwing: error)
      }
    }
  }
  
  private func notifyChanges() {
    guard let context = storage as? NSManagedObjectContext else { return }
    context.processPendingChanges()
  }
}

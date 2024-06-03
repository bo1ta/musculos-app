//
//  CoreDataWriteOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation

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
      } catch {
        self.continuation.resume(throwing: error)
      }
    }
  }
}

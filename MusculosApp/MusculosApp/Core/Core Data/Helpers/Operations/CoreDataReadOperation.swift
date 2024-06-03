//
//  CoreDataReadOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation

final class CoreDataReadOperation<T>: Operation {
  let task: (StorageType) -> T
  let storage: StorageType
  let continuation: CheckedContinuation<T, Never>
  
  init(task: @escaping (StorageType) -> T, storage: StorageType, continuation: CheckedContinuation<T, Never>) {
    self.task = task
    self.storage = storage
    self.continuation = continuation
  }
  
  override func main() {
    storage.performAsync {
      let result = self.task(self.storage)
      self.continuation.resume(returning: result)
    }
  }
}

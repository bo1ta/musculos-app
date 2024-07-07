//
//  CoreDataReadOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation

final class CoreDataReadOperation<ResultType>: Operation, @unchecked Sendable {
  let task: (StorageType) -> ResultType
  let storage: StorageType
  let continuation: CheckedContinuation<ResultType, Never>
  
  init(task: @escaping (StorageType) -> ResultType, storage: StorageType, continuation: CheckedContinuation<ResultType, Never>) {
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

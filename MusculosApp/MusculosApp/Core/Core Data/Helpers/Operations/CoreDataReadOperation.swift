//
//  CoreDataReadOperation.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 03.06.2024.
//

import Foundation

final class CoreDataReadOperation<ResultType>: AsyncOperation, @unchecked Sendable {
  let closure: CoreDataReadClosure<ResultType>
  let storage: StorageType
  let continuation: CheckedContinuation<ResultType, Never>
  
  init(storage: StorageType, closure: @escaping CoreDataReadClosure<ResultType>, continuation: CheckedContinuation<ResultType, Never>) {
    self.closure = closure
    self.storage = storage
    self.continuation = continuation
  }
  
  override func main() {
    storage.performAsync {
      let result = self.closure(self.storage)
      self.continuation.resume(returning: result)
      self.state = .finished
    }
  }
}

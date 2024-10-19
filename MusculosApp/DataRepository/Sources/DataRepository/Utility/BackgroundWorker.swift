//
//  BackgroundWorker.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Queue

final class BackgroundWorker {
  private let backgroundQueue = AsyncQueue()

  @discardableResult func queueOperation<Success>(
    priority: TaskPriority? = nil,
    @_inheritActorContext operation: @escaping @Sendable () async throws -> Success
  ) -> Task<Success, Error> where Success : Sendable {
    return backgroundQueue.addOperation(priority: priority, operation: operation)
  }
}

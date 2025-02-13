//
//  BackgroundWorker.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Foundation
import Queue
import Utility

final class BackgroundWorker: Sendable {
  private let backgroundQueue = AsyncQueue(attributes: [.concurrent, .publishErrors])

  var errorSequence: AsyncQueue.ErrorSequence {
    backgroundQueue.errorSequence
  }

  @discardableResult
  func queueOperation<Success: Sendable>(
    priority: TaskPriority? = .low,
    operation: @escaping @Sendable () async throws -> Success)
    -> Task<Success, Error>
  {
    backgroundQueue.addOperation(priority: priority) {
      try await operation()
    }
  }

  func waitForAll() async {
    _ = await backgroundQueue.addBarrierOperation { }.result
  }
}

//
//  BackgroundWorker.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Foundation
import Utility
import Queue

final class BackgroundWorker: Sendable {
  private let backgroundQueue = AsyncQueue()

  @discardableResult func queueOperation<Success: Sendable>(
    priority: TaskPriority? = nil,
    operationType: OperationType = .remote,
    @_inheritActorContext operation: @escaping @Sendable () async throws -> Success
  ) -> Task<Success, Error> {
    return backgroundQueue.addOperation(priority: priority) {
      try await operation()
    }
  }

  public func waitForAll() async {
    _ = await backgroundQueue.addOperation {}.result
  }
}

// MARK: - Types

extension BackgroundWorker {
  enum OperationType {
    case local
    case remote

    var maxRetryAttempts: Int {
      switch self {
      case .local: return 0
      case .remote: return 3
      }
    }

    var shouldRetry: (Error) -> Bool {
      switch self {
      case .local:
        return { error in
          MusculosLogger.logError(error, message: "Error running local operation", category: .backgroundWorker)
          return false
        }
      case .remote:
        return { error in
          let isRetryable = MusculosError.isRetryableError(error)
          MusculosLogger.logError(error, message: "Error running remote operation", category: .backgroundWorker, properties: ["is_retryable": isRetryable])
          return isRetryable
        }
      }
    }
  }

  enum RetryError: Error {
    case maxAttemptsReached(Error, attempts: Int)
  }
}

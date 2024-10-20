//
//  BackgroundWorker.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 19.10.2024.
//

import Foundation
import Utility
import Queue

final class BackgroundWorker: @unchecked Sendable {
  private let backgroundQueue = AsyncQueue()

  @discardableResult func queueOperation<Success>(
    priority: TaskPriority? = nil,
    operationType: OperationType = .remote,
    @_inheritActorContext operation: @escaping @Sendable () async throws -> Success
  ) -> Task<Success, Error> where Success : Sendable {
    return backgroundQueue.addOperation(priority: priority) {
      try await self.withRetry(attempts: operationType.maxRetryAttempts, shouldRetry: operationType.shouldRetry, operation: operation)
    }
  }

  public func waitForAll() async {
    _ = await backgroundQueue.addOperation {}.result
  }

  private func withRetry<Success>(
    attempts: Int,
    baseDelay: TimeInterval = 0.5,
    exponentialBackoff: Bool = true,
    shouldRetry: (Error) -> Bool = { _ in true },
    @_inheritActorContext operation: @Sendable () async throws -> Success
  ) async throws -> Success {
    guard attempts > 0 else {
      return try await operation()
    }

    var remainingAttempts = attempts
    var currentDelay = baseDelay

    repeat {
      do {
        return try await operation()
      } catch let error {
        remainingAttempts -= 1

        logRetryError(error, currentAttempt: remainingAttempts, currentDelay: currentDelay)

        guard shouldRetry(error), remainingAttempts > 0 else {
          throw RetryError.maxAttemptsReached(error, attempts: attempts)
        }

        try await Task.sleep(for: .seconds(currentDelay))

        if exponentialBackoff {
          currentDelay *= 2
        }
      }
    } while remainingAttempts > 0

    throw RetryError.maxAttemptsReached(MusculosError.unknownError, attempts: attempts)
  }

  private func logRetryError(_ error: Error, currentAttempt: Int, currentDelay: Double) {
    MusculosLogger.logError(error, message: "Retrying background operation", category: .backgroundWorker, properties: ["current_attempt": currentAttempt, "current_delay": currentDelay])
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
      case .remote: return { error in
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

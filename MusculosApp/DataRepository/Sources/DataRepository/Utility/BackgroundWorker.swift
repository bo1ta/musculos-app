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
    retryAttempts: Int = 3,
    @_inheritActorContext operation: @escaping @Sendable () async throws -> Success
  ) -> Task<Success, Error> where Success : Sendable {
    return backgroundQueue.addOperation(priority: priority) {
      try await self.withRetry(attempts: retryAttempts, operation: operation)
    }
  }

  enum RetryError: Error {
    case maxAttemptsReached(Error, attempts: Int)
  }

  private func withRetry<Success>(
    attempts: Int,
    baseDelay: TimeInterval = 0.5,
    exponentialBackoff: Bool = true,
    shouldRetry: (Error) -> Bool = { _ in true },
    @_inheritActorContext operation: @Sendable () async throws -> Success
  ) async throws -> Success {
    var remainingAttempts = attempts
    var currentDelay = baseDelay

    while remainingAttempts > 0 {
      do {
        return try await operation()
      } catch let error {
        remainingAttempts -= 1

        guard shouldRetry(error), remainingAttempts > 0 else {
          throw RetryError.maxAttemptsReached(error, attempts: attempts)
        }

        try await Task.sleep(for: .seconds(currentDelay))

        if exponentialBackoff {
          currentDelay *= 2
        }
      }
    }

    throw RetryError.maxAttemptsReached(MusculosError.unknownError, attempts: attempts)
  }
}

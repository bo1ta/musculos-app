//
//  Task+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation

private let exponentialBackoff = 2.0

public extension Task {
  @discardableResult static func retrying(
    priority: TaskPriority? = nil,
    maxRetryCount: Int = 3,
    retryDelay: TimeInterval = 1,
    shouldRetry: @Sendable @escaping (Error) -> Bool = { _ in true },
    operation: @Sendable @escaping () async throws -> Success
  ) -> Task<Success, Error> {
    Task<Success, Error>(priority: priority) {
      var currentDelay = retryDelay

      for _ in 0 ..< maxRetryCount {
        do {
          return try await operation()
        } catch {
          guard shouldRetry(error) else {
            throw error
          }

          try await Task<Never, Never>.sleep(for: .seconds(currentDelay))
          currentDelay *= exponentialBackoff

          continue
        }
      }

      try Task<Never, Never>.checkCancellation()
      return try await operation()
    }
  }
}

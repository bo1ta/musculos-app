//
//  RetryMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation
import Utility

struct RetryMiddleware: RequestMiddleware {
  var priority: MiddlewarePriority { .retryMiddleware }

  let maxRetryCount: Int
  let retryDelay: TimeInterval

  init(maxRetryCount: Int = 3, retryDelay: TimeInterval = 1.0) {
    self.maxRetryCount = maxRetryCount
    self.retryDelay = retryDelay
  }

  func intercept(request: APIRequest, proceed: @Sendable @escaping (APIRequest) async throws -> (Data, URLResponse)) async throws -> (Data, URLResponse) {
    try await retrying(maxRetryCount: maxRetryCount, retryDelay: retryDelay, shouldRetry: shouldRetry) {
      try await proceed(request)
    }
  }

  private func shouldRetry(_ error: Error) -> Bool {
    guard let error = error as? MusculosError else {
      return false
    }

    switch error {
    case .badRequest, .notFound:
      return true
    default:
      return false
    }
  }

  private func retrying<Success>(
    maxRetryCount: Int = 3,
    retryDelay: TimeInterval = 1,
    shouldRetry: @Sendable @escaping (Error) -> Bool,
    operation: @Sendable @escaping () async throws -> Success
  ) async throws -> Success {
    var currentDelay = retryDelay

    for attempt in 0 ..< maxRetryCount {
      do {
        return try await operation()
      } catch {
        guard shouldRetry(error) else {
          throw error
        }

        if attempt < maxRetryCount - 1 {
          try await Task.sleep(nanoseconds: UInt64(currentDelay * 1_000_000_000))
          currentDelay *= 2.0
        }
      }
    }

    return try await operation()
  }
}

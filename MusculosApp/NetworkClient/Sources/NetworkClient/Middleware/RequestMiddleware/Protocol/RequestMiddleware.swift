//
//  RequestMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation

// MARK: - MiddlewarePriority

enum MiddlewarePriority: Int {
  case authorizationMiddleware = 3
  case connectivityMiddleware = 2
  case defaultMiddleware = 0
  case retryMiddleware = -1
}

// MARK: - RequestMiddleware

protocol RequestMiddleware: Sendable {
  var priority: MiddlewarePriority { get }

  func intercept(request: APIRequest, proceed: @Sendable @escaping (APIRequest) async throws -> (Data, URLResponse)) async throws
    -> (Data, URLResponse)
}

extension RequestMiddleware {
  var priority: MiddlewarePriority { .defaultMiddleware }
}

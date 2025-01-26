//
//  ResponseMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation

// MARK: - ResponseMiddlewarePriority

enum ResponseMiddlewarePriority: Int {
  case authChecker = 2
  case logging = 1
  case `default` = 0
}

// MARK: - ResponseMiddleware

protocol ResponseMiddleware: Sendable {
  var priority: ResponseMiddlewarePriority { get }

  func intercept(response: (Data, URLResponse), for request: APIRequest) async throws -> (Data, URLResponse)
}

extension ResponseMiddleware {
  var priority: ResponseMiddlewarePriority { .default }
}

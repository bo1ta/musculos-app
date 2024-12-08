//
//  MiddlewarePipeline.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation
import Utility

struct MiddlewarePipeline {
  private let requestMiddlewares: [RequestMiddleware]
  private let responseMiddlewares: [ResponseMiddleware]

  init(requestMiddlewares: [RequestMiddleware] = [], responseMiddlewares: [ResponseMiddleware] = []) {
    self.requestMiddlewares = requestMiddlewares
    self.responseMiddlewares = responseMiddlewares
  }

  func execute(request: APIRequest, using session: URLSession) async throws -> (Data, URLResponse) {
    var modifiedRequest = request

    let requestHandler: @Sendable (APIRequest) async throws -> (Data, URLResponse) = { modifiedRequest in
      guard let urlRequest = modifiedRequest.asURLRequest() else {
        throw MusculosError.badRequest
      }

      return try await session.data(for: urlRequest)
    }

    let response = try await executeRequestMiddlewares(request: request, handler: requestHandler)
    return try await executeResponseMiddlewares(response: response, for: request)
  }

  private func executeRequestMiddlewares(
    request: APIRequest,
    handler: @Sendable @escaping (APIRequest) async throws -> (Data, URLResponse)
  ) async throws -> (Data, URLResponse) {
    var nextHandler = handler

    for middleware in requestMiddlewares {
      let currentHandler = nextHandler

      nextHandler = { modifiedRequest in
        try await middleware.intercept(request: modifiedRequest, proceed: currentHandler)
      }
    }

    return try await nextHandler(request)
  }

  private func executeResponseMiddlewares(
    response: (Data, URLResponse),
    for request: APIRequest
  ) async throws -> (Data, URLResponse) {
    var modifiedResponse = response

    for middleware in responseMiddlewares {
      modifiedResponse = try await middleware.intercept(response: modifiedResponse, for: request)
    }

    return modifiedResponse
  }
}
//
//  MusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Combine
import Utility

public protocol MusculosClientProtocol: Sendable {
  func dispatch(_ request: APIRequest) async throws -> Data
}

public struct MusculosClient: MusculosClientProtocol {
  private let pipeline: MiddlewarePipeline
  private let urlSession: URLSession

  init(urlSession: URLSession = .shared, requestMiddlewares: [RequestMiddleware] = [], responseMiddlewares: [ResponseMiddleware] = []) {
    self.urlSession = urlSession
    self.pipeline = MiddlewarePipeline(requestMiddlewares: requestMiddlewares, responseMiddlewares: responseMiddlewares)
  }
  
  public func dispatch(_ request: APIRequest) async throws -> Data {
    let (data, _) = try await pipeline.execute(request: request, using: urlSession)
    return data
  }
}

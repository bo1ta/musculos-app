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

  private let urlSession = {
    let urlSession = URLSession(configuration: .default)
    urlSession.configuration.urlCache = URLCache(memoryCapacity: 25 * 1024 * 1024, diskCapacity: 50 * 1024 * 1024)
    urlSession.configuration.requestCachePolicy = .useProtocolCachePolicy
    return urlSession
  }()

  init(requestMiddlewares: [RequestMiddleware] = [], responseMiddlewares: [ResponseMiddleware] = []) {
    self.pipeline = MiddlewarePipeline(requestMiddlewares: requestMiddlewares, responseMiddlewares: responseMiddlewares)
  }
  
  public func dispatch(_ request: APIRequest) async throws -> Data {
    let (data, _) = try await pipeline.execute(request: request, using: urlSession)
    return data
  }
}

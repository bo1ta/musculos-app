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

  private let urlSession: URLSession = {
    let urlSession = URLSession(configuration: .default)
    urlSession.configuration.urlCache = URLCache(memoryCapacity: CacheCapacity.cacheMemoryCapacity, diskCapacity: CacheCapacity.cacheDiskCapacity)
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

private enum CacheCapacity {
  static let cacheMemoryCapacity: Int = 25 * 1024 * 1024 // 25mb
  static let cacheDiskCapacity : Int = 50 * 1024 * 1024 // 50mb
}

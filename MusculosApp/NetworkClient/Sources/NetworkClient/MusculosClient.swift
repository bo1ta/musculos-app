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
  var urlSession: URLSession
  
  public init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  public func dispatch(_ request: APIRequest) async throws -> Data {
    guard let urlRequest = await request.asURLRequest() else {
      throw MusculosError.badRequest
    }
    
    let (data, response) = try await self.urlSession.data(for: urlRequest)
    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
      if MusculosError.httpError(httpResponse.statusCode) == .unauthorized {
        NotificationCenter.default.post(name: .authTokenDidFail, object: nil)
      }

      throw MusculosError.httpError(httpResponse.statusCode)
    }
    return data
  }
}

//
//  MusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Combine
import Utility

protocol MusculosClientProtocol: Sendable {
  func dispatch(_ request: APIRequest) async throws -> Data
}

struct MusculosClient: MusculosClientProtocol {
  var urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func dispatch(_ request: APIRequest) async throws -> Data {
    guard let urlRequest = await request.asURLRequest() else {
      throw MusculosError.badRequest
    }
    
    let (data, response) = try await self.urlSession.data(for: urlRequest)
    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
      throw MusculosError.httpError(httpResponse.statusCode)
    }
    return data
  }
}

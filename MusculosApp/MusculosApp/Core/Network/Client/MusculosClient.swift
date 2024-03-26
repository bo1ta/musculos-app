//
//  MusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Combine

struct MusculosClient: MusculosClientProtocol {
  var urlSession: URLSession
  
  init(urlSession: URLSession = .shared) {
    self.urlSession = urlSession
  }
  
  func dispatch(_ request: APIRequest) async throws -> Data {
    guard let urlRequest = request.asURLRequest() else {
      throw MusculosError.badRequest
    }
    
    let (data, response) = try await self.urlSession.data(for: urlRequest)
    if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
      throw MusculosError.httpError(httpResponse.statusCode)
    }
    return data
  }


  func dispatchPublisher<T: Codable>(_ request: APIRequest) -> AnyPublisher<T, MusculosError> {
    guard let urlRequest = request.asURLRequest() else {
      return Fail<T, MusculosError>(error: MusculosError.badRequest).eraseToAnyPublisher()
    }

    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    return self.urlSession.dataTaskPublisher(for: urlRequest)
      .map({ data, _ in
        return data
      })
      .decode(type: T.self, decoder: decoder)
      .receive(on: DispatchQueue.main)
      .mapError({ _ in
        return MusculosError.badRequest
      })
      .eraseToAnyPublisher()
  }
}

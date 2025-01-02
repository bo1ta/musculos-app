//
//  StubMusculosClient.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation

struct StubMusculosClient: MusculosClientProtocol {
  func dispatch(_ request: APIRequest) async throws -> Data {
    return Data()
  }
}

//
//  StubMusculosClient.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Foundation

struct StubMusculosClient: MusculosClientProtocol {
  func dispatch(_: APIRequest) async throws -> Data {
    Data()
  }
}

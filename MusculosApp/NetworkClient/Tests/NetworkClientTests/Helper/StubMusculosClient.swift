//
//  StubMusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Foundation
@testable import NetworkClient
import Testing
@testable import Utility

struct StubMusculosClient: MusculosClientProtocol, @unchecked Sendable {
  var expectedEndpoint: Endpoint?
  var expectedMethod: HTTPMethod?
  var expectedBody: [String: Any]?
  var expectedOpk: String?
  var expectedQueryParams: [URLQueryItem]?
  var expectedResponseData: Data?
  var expectedAuthToken: String?

  func dispatch(_ request: APIRequest) async throws -> Data {
    if let expectedEndpoint {
      #expect(request.endpoint.path == expectedEndpoint.path)
    }
    if let expectedMethod {
      #expect(request.method == expectedMethod)
    }
    if let expectedBody {
      #expect(NSDictionary(dictionary: request.body ?? [:]).isEqual(to: expectedBody))
    }
    if let expectedOpk {
      #expect(request.opk == expectedOpk)
    }
    if let expectedQueryParams {
      #expect(request.queryParams == expectedQueryParams)
    }
    if let expectedAuthToken {
      #expect(request.authToken == expectedAuthToken)
    }

    return expectedResponseData ?? Data()
  }
}

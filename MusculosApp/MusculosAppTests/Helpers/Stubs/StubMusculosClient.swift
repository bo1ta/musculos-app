//
//  StubMusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Foundation
import Testing
@testable import NetworkClient
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
    #expect(request.path.path == expectedEndpoint!.path)
    #expect(request.method == expectedMethod)
    #expect(request.opk == expectedOpk)
    #expect(request.queryParams == expectedQueryParams)
    #expect(NSDictionary(dictionary: request.body ?? [:]).isEqual(to: expectedBody ?? [:]))

    if let expectedAuthToken {
      #expect(request.authToken == expectedAuthToken)
    }

    return expectedResponseData ?? Data()
  }
}

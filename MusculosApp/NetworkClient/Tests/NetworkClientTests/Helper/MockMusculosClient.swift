//
//  MockMusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Foundation
import Testing
import Utility

public struct MockMusculosClient: MusculosClientProtocol, @unchecked Sendable {
  public var expectedEndpoint: Endpoint?
  public var expectedMethod: HTTPMethod?
  public var expectedBody: [String: Any]?
  public var expectedOpk: String?
  public var expectedQueryParams: [URLQueryItem]?
  public var expectedResponseData: Data?
  public var expectedAuthToken: String?

  public func dispatch(_ request: APIRequest) async throws -> Data {
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

//
//  ResponseMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation

protocol ResponseMiddleware: Sendable {
  func intercept(response: (Data, URLResponse), for request: APIRequest) async throws -> (Data, URLResponse)
}

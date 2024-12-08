//
//  RequestMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation

protocol RequestMiddleware: Sendable {
  func intercept(request: APIRequest, proceed: @Sendable @escaping (APIRequest) async throws -> (Data, URLResponse)) async throws -> (Data, URLResponse)
}

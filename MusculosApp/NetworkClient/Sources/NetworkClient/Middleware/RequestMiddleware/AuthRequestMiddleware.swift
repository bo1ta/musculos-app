//
//  AuthRequestMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation
import Storage

struct AuthRequestMiddleware: RequestMiddleware {
  func intercept(request: APIRequest, proceed: @escaping (APIRequest) async throws -> (Data, URLResponse)) async throws -> (Data, URLResponse) {
    guard request.endpoint.isAuthorizationRequired, let authToken else {
      return try await proceed(request)
    }
    print("od")

    var newRequest = request
    newRequest.authToken = authToken
    return try await proceed(newRequest)
  }

  private var authToken: String? {
    return StorageContainer.shared.userManager().currentUserSession?.token.value
  }
}

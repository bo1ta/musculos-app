//
//  AuthResponseMiddleware.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 08.12.2024.
//

import Foundation
import Utility

struct AuthCheckerMiddleware: ResponseMiddleware {
  var priority: ResponseMiddlewarePriority { .authChecker }

  func intercept(response: (Data, URLResponse), for request: APIRequest) async throws -> (Data, URLResponse) {
    let (_, urlResponse) = response

    if let httpResponse = urlResponse as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
      if isInvalidTokenResponse(httpResponse: httpResponse) {
        sendInvalidTokenNotification()
      }

      throw MusculosError.httpError(httpResponse.statusCode)
    }

    return response
  }

  private func isInvalidTokenResponse(httpResponse: HTTPURLResponse) -> Bool {
    return MusculosError.httpError(httpResponse.statusCode) == .unauthorized
  }

  private func sendInvalidTokenNotification() {
    NotificationCenter.default.post(name: .authTokenDidFail, object: nil)
  }
}

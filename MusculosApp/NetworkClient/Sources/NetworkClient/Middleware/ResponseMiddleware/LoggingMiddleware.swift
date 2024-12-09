//
//  LoggingMiddleware.swift
//  Networking
//
//  Created by Solomon Alexandru on 09.12.2024.
//

import Foundation
import Utility

struct LoggingMiddleware: ResponseMiddleware {
  var priority: ResponseMiddlewarePriority { .logging }

  func intercept(response: (Data, URLResponse), for request: APIRequest) async throws -> (Data, URLResponse) {
    let requestMethod = request.method.rawValue.uppercased()
    let requestPath = request.endpoint.path

    Logger.logInfo(message: "Did make \(requestMethod) request to \(requestPath)", file: "", function: "", line: 0)

    if let httpUrlResponse = response.1 as? HTTPURLResponse, !(200...300 ~= httpUrlResponse.statusCode) {
      Logger.logError(
        MusculosError.httpError(httpUrlResponse.statusCode),
        message: "\(requestMethod) request to \(requestPath) failed with status code \(httpUrlResponse.statusCode)",
        file: "",
        function: "",
        line: 0
      )
    }

    return response
  }
}

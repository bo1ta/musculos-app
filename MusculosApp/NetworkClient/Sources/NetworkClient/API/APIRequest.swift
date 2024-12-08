//
//  APIRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Utility
import Models

public struct APIRequest: @unchecked Sendable {
  public var method: HTTPMethod
  public var endpoint: Endpoint
  public var queryParams: [URLQueryItem]?
  public var body: [String: Any]?
  public var opk: String?
  public var authToken: String?

  var contentType: String { "application/json" }

  public func asURLRequest() -> URLRequest? {
    guard var baseURL = APIEndpoint.baseWithEndpoint(endpoint: endpoint) else { return nil }

    if let opk {
      baseURL.appendPathComponent(opk)
    }

    if let queryParams {
      var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: false)
      components?.queryItems = queryParams
      if let urlWithQuery = components?.url {
        baseURL = urlWithQuery
      }
    }
    
    var request = URLRequest(url: baseURL)
    request.httpMethod = self.method.rawValue

    if let body = self.body {
      request.httpBody = self.requestBody(from: body)
    }

    var newHeaders: [String: String] = [:]
    newHeaders[HTTPHeaderConstant.contentType] = self.contentType

    if endpoint.isAuthorizationRequired, let authToken {
        newHeaders[HTTPHeaderConstant.authorization] = "Bearer \(authToken)"
    }
    
    request.allHTTPHeaderFields = newHeaders
    return request
  }

  private func requestBody(from body: [String: Any]) -> Data? {
    do {
      let httpBody = try JSONSerialization.data(withJSONObject: body)
      return httpBody
    } catch {
      return nil
    }
  }
}

//
//  APIRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Factory
import Utility
import Models
import Storage

public struct APIRequest {
  @Injected(\StorageContainer.userManager) var userManager

  public var method: HTTPMethod
  public var endpoint: Endpoint
  public var queryParams: [URLQueryItem]?
  public var body: [String: Any]?
  public var opk: String?

  var contentType: String { "application/json" }

  public func asURLRequest() async -> URLRequest? {
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

    if endpoint.isAuthorizationRequired {
      if let authToken {
        newHeaders[HTTPHeaderConstant.authorization] = "Bearer \(authToken)"
      } else {
        return nil
      }
    }
    
    request.allHTTPHeaderFields = newHeaders
    return request
  }

  public var authToken: String? {
    return userManager.currentUserSession?.token.value
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

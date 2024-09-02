//
//  APIRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation
import Factory
import Utility

struct APIRequest {
  var method: HTTPMethod
  var path: Endpoint
  var queryParams: [URLQueryItem]?
  var body: [String: Any]?
  var authToken: String?
  var opk: String?

  var contentType: String { return "application/json" }

  func asURLRequest() async -> URLRequest? {
    guard var baseURL = APIEndpoint.baseWithEndpoint(endpoint: path) else { return nil }

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
    
    if let authToken = self.authToken {
      newHeaders[HTTPHeaderConstant.authorization] = "Bearer \(authToken)"
    } else {
      if let fetchedToken = currentSession?.authToken {
        newHeaders[HTTPHeaderConstant.authorization] = "Bearer \(fetchedToken)"
      }
    }
    
    request.allHTTPHeaderFields = newHeaders

    return request
  }

  private var currentSession: UserSession? {
    return Container.shared.userManager().currentSession()
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

//
//  APIRequest.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.09.2023.
//

import Foundation

struct APIRequest {
    var method: HTTPMethod
    var path: Endpoint
    var headers: [String: String]?
    var queryParams: [String: String]?
    var body: [String: Any]?
    var authToken: String?
    
    var contentType: String { return "application/json" }
    
    func asURLRequest() -> URLRequest? {
        guard
            let url = URL(string: APIEndpoint.baseWithEndpoint(endpoint: path))
        else { return nil }
        
        var request = URLRequest(url: url)
        request.httpMethod = self.method.rawValue
        
        if let body = self.body {
            request.httpBody = self.requestBody(from: body)
        }
        
        var newHeaders = headers ?? [String: String]()
        newHeaders[HTTPHeaderConstants.contentType] = self.contentType
        if let authToken = self.authToken {
            newHeaders[HTTPHeaderConstants.authorization] = authToken
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

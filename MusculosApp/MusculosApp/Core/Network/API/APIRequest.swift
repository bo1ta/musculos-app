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
    var queryParams: [URLQueryItem]?
    var body: [String: Any]?
    var authToken: String?
    var opk: String?
    
    var contentType: String { return "application/json" }
    
    var headers: [String: String] = [
        "X-RapidAPI-Key": "10f816fad9mshb1b3051df5805d6p159f6cjsn59fc62f2a609",
        "X-RapidAPI-Host": "exercisedb.p.rapidapi.com"
    ]
    
    func asURLRequest() -> URLRequest? {
        guard var baseURL = URL(string: APIEndpoint.baseWithEndpoint(endpoint: path)) else { return nil }
        
        if let opk = opk {
            baseURL.appendPathComponent(opk)
        }
        
        if let queryParams = self.queryParams {
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
        
        var newHeaders = self.headers
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


//
//  Request.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation
import Combine

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any]? { get }
    var headers: [String: String]? { get }
    var authToken: String? { get }
    associatedtype ReturnType: Codable
}

extension Request {
    var method: HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String: String]? { return nil }
    var body: [String: Any]? { return nil }
    var headers: [String: String]? { return nil }
    var authToken: String? { return UserDefaultsWrapper.shared.authToken }
}

extension Request {
    private func requestBody(from body: [String: Any]) -> Data? {
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: body)
            return httpBody
        } catch {
            print("Error serializing JSON: \(error)")
            return nil
        }
    }
    
    func asURLRequest(baseURL: String) -> URLRequest? {
        guard
            let urlComponents = URLComponents(string: baseURL),
            let finalURL = urlComponents.url
        else { return nil }
        
        var request = URLRequest(url: finalURL)
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
}

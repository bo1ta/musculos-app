//
//  Request.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation
import Combine

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public enum HTTPHeader: String {
    case contentType = "Content-Type"
}

public protocol Request {
    var path: String { get }
    var method: HTTPMethod { get }
    var contentType: String { get }
    var body: [String: Any] { get }
    var headers: [String: String]? { get }
    associatedtype ReturnType: Codable
}

extension Request {
    var method: HTTPMethod { return .get }
    var contentType: String { return "application/json" }
    var queryParams: [String: String]? { return nil }
    var headers: [String: String]? { return nil }
}

extension Request {
    private func requestBody(from params: [String: Any]?) -> Data? {
        guard let otherParams = params else { return nil }
        do {
            let httpBody = try JSONSerialization.data(withJSONObject: otherParams)
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
        request.httpBody = self.requestBody(from: self.body)
        
        var newHeaders = headers ?? [String: String]()
        newHeaders[HTTPHeader.contentType.rawValue] = self.contentType
        request.allHTTPHeaderFields = newHeaders
        
        return request
    }
}

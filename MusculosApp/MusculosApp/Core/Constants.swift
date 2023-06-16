//
//  Constants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.06.2023.
//

import Foundation

public enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
}

public class HTTPHeaderConstants: NSObject {
    static let contentType = "Content-Type"
    static let authorization = "Authorization"
}

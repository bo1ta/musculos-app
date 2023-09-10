//
//  NetworkRequestError.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation


enum NetworkRequestError: LocalizedError, Equatable, CustomStringConvertible {
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case notFound
    case error4xx(_ code: Int)
    case serverError
    case error5xx(_ code: Int)
    case decodingError
    case urlSessionFailed(_ error: URLError)
    case unknownError
    
    var description: String {
        switch self {
        case .invalidRequest:
            return "Invalid request"
        case .badRequest:
            return "Bad request"
        case .unauthorized:
            return "Unauthorized"
        case .forbidden:
            return "Forbidden"
        case .notFound:
            return "Not found"
        case .error4xx(let code):
            return "Client error: \(code)"
        case .serverError:
            return "Server error"
        case .error5xx(let code):
            return "Server error: \(code)"
        case .decodingError:
            return "Decoding error"
        case .urlSessionFailed(let error):
            return "URL session failed: \(error.localizedDescription)"
        case .unknownError:
            return "Unknown error"
        }
    }
}

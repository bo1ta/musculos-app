//
//  MusculosError.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation

public enum MusculosError: LocalizedError, CustomStringConvertible {
  case invalidRequest, badRequest, unauthorized, forbidden, notFound, serverError, decodingError, unknownError
  case cancelled
  case offline
  case error4xx(_ code: Int)
  case error5xx(_ code: Int)
  case urlSessionFailed(_ error: URLError)
  
  public var description: String {
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
    case .cancelled:
      return "Cancelled"
    case .offline:
      return "Offline"
    }
  }
  
  public static func httpError(_ statusCode: Int) -> MusculosError {
    switch statusCode {
    case 400:
      return .badRequest
    case 401:
      return .unauthorized
    case 403:
      return .forbidden
    case 404:
      return .notFound
    case 402, 405...499:
      return .error4xx(statusCode)
    case 500:
      return .serverError
    case 501...599:
      return .error5xx(statusCode)
    default:
      return .unknownError
    }
  }

  public static func isRetryableError(_ error: Error) -> Bool {
    guard let error = error as? MusculosError else {
      return false
    }
    switch error {
    case .badRequest, .unauthorized, .forbidden, .notFound:
      return true
    default:
      return false
    }
  }
}

extension MusculosError: Equatable {
  public static func == (lhs: MusculosError, rhs: MusculosError) -> Bool {
    return lhs.description == rhs.description
  }
}

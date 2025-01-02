//
//  MusculosError.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation

// MARK: - MusculosError

public enum MusculosError: LocalizedError, CustomStringConvertible {
  case networkError(NetworkError)
  case storageError(StorageError)
  case decodingError
  case unknownError
  case cancelled
  case offline
  case unexpectedNil

  public var description: String {
    switch self {
    case .networkError(let error): "Network error: \(error.description)"
    case .storageError(let error): "Storage error: \(error.description)"
    case .decodingError: "Decoding error"
    case .unknownError: "Unknown error"
    case .cancelled: "Cancelled"
    case .offline: "Offline"
    case .unexpectedNil: "Unexpected nil"
    }
  }

  public static func isRetryableError(_ error: Error) -> Bool {
    guard let error = error as? MusculosError.NetworkError else {
      return false
    }
    switch error {
    case .badRequest, .notFound:
      return true
    default:
      return false
    }
  }
}

// MARK: MusculosError.NetworkError

extension MusculosError {
  public enum NetworkError: LocalizedError, CustomStringConvertible, Equatable {
    case unknownError
    case notFound
    case invalidRequest
    case badRequest
    case unauthorized
    case forbidden
    case serverError
    case error4xx(_ code: Int)
    case error5xx(_ code: Int)
    case urlSessionFailed(_ error: URLError)

    public var description: String {
      switch self {
      case .unknownError: "Unknown error"
      case .notFound: "Not found"
      case .invalidRequest: "Invalid request"
      case .badRequest: "Bad request"
      case .unauthorized: "Unauthorized"
      case .forbidden: "Forbidden"
      case .error4xx(let code): "Client error: \(code)"
      case .serverError: "Server error"
      case .error5xx(let code): "Server error: \(code)"
      case .urlSessionFailed(let error): "URL session failed: \(error.localizedDescription)"
      }
    }

    public static func ==(lhs: NetworkError, rhs: NetworkError) -> Bool {
      lhs.description == rhs.description
    }

    public static func httpError(_ statusCode: Int) -> NetworkError {
      switch statusCode {
      case 400:
        .badRequest
      case 401:
        .unauthorized
      case 403:
        .forbidden
      case 404:
        .notFound
      case 402, 405 ... 499:
        .error4xx(statusCode)
      case 500:
        .serverError
      case 501 ... 599:
        .error5xx(statusCode)
      default:
        .unknownError
      }
    }
  }
}

// MARK: MusculosError.StorageError

extension MusculosError {
  public enum StorageError: LocalizedError, CustomStringConvertible, Equatable {
    case invalidUser
    case syncingFailed(String)

    public var description: String {
      switch self {
      case .invalidUser:
        return "Invalid user"
      case .syncingFailed(let message):
        return "Syncing failed: \(message)"
      }
    }

    public static func ==(lhs: StorageError, rhs: StorageError) -> Bool {
      lhs.description == rhs.description
    }
  }
}

// MARK: Equatable

extension MusculosError: Equatable {
  public static func ==(lhs: MusculosError, rhs: MusculosError) -> Bool {
    lhs.description == rhs.description
  }
}

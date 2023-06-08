//
//  NetworkRequestError.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation


enum NetworkRequestError: LocalizedError, Equatable {
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
}

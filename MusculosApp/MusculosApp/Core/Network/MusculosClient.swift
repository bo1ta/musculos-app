//
//  MusculosClient.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation
import Combine

protocol MusculosClientProtocol {
    func dispatch(_ request: APIRequest) async throws -> Data
}

struct MusculosClient: MusculosClientProtocol {
    var urlSession: URLSession
    
    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func dispatch(_ request: APIRequest) async throws -> Data {
        guard let urlRequest = request.asURLRequest() else {
            throw NetworkRequestError.badRequest
        }
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        let (data, response) = try await self.urlSession.data(for: urlRequest)
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            throw httpError(response.statusCode)
        }
        
        return data
    }
    
    private func httpError(_ statusCode: Int) -> NetworkRequestError {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 403: return .forbidden
        case 404: return .notFound
        case 402, 405...499: return .error4xx(statusCode)
        case 500: return .serverError
        case 501...599: return .error5xx(statusCode)
        default: return .unknownError
        }
    }
    
    private func handleError(_ error: Error) -> NetworkRequestError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as NetworkRequestError:
            return error
        default:
            return .unknownError
        }
    }
}

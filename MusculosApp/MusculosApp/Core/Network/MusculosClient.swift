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
    func dispatchPublisher<T: Codable>(_ request: APIRequest) -> AnyPublisher<T, MusculosError>
}

struct MusculosClient: MusculosClientProtocol {
    var urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    func dispatch(_ request: APIRequest) async throws -> Data {
        guard let urlRequest = request.asURLRequest() else {
            throw MusculosError.badRequest
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        let (data, response) = try await self.urlSession.data(for: urlRequest)
        if let response = response as? HTTPURLResponse, !(200...299).contains(response.statusCode) {
            throw httpError(response.statusCode)
        }

        return data
    }

    func dispatchPublisher<T: Codable>(_ request: APIRequest) -> AnyPublisher<T, MusculosError> {
        guard let urlRequest = request.asURLRequest() else {
            return Fail<T, MusculosError>(error: MusculosError.badRequest).eraseToAnyPublisher()
        }

        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return self.urlSession.dataTaskPublisher(for: urlRequest)
            .map({ data, _ in
                return data
            })
            .decode(type: T.self, decoder: decoder)
            .receive(on: DispatchQueue.main)
            .mapError({ _ in
                return MusculosError.badRequest
            })
            .eraseToAnyPublisher()
    }

    private func httpError(_ statusCode: Int) -> MusculosError {
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

    private func handleError(_ error: Error) -> MusculosError {
        switch error {
        case is Swift.DecodingError:
            return .decodingError
        case let urlError as URLError:
            return .urlSessionFailed(urlError)
        case let error as MusculosError:
            return error
        default:
            return .unknownError
        }
    }
}

//
//  NetworkDispatcher.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.06.2023.
//

import Foundation
import Combine


struct NetworkDispatcher {
    let urlSession: URLSession
    
    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }
    
    func dispatch<ReturnType: Codable>(request: URLRequest) -> AnyPublisher<ReturnType, NetworkRequestError> {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        print("odata")
        NetworkLogger.logRequest(request)
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                if let response = response as? HTTPURLResponse,
                   !(200...299).contains(response.statusCode) {
                    throw httpError(response.statusCode)
                }
                return data
            }
            .flatMap({ (data: Data) -> AnyPublisher<ReturnType, Error> in
                do {
                    let result = try decoder.decode(ReturnType.self, from: data)
                    return Just(result)
                        .setFailureType(to: Error.self)
                        .eraseToAnyPublisher()
                } catch {
                    print("Decoding error:", error)
                    print("Data:", String(data: data, encoding: .utf8) ?? "")
                    return Fail(error: error)
                        .eraseToAnyPublisher()
                }
            })
            .mapError { error in
                handleError(error)
            }
            .eraseToAnyPublisher()
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

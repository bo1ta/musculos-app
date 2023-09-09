//
//  DeocdableModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.09.2023.
//

import Foundation

protocol DecodableModel {
    static func createFrom(_ data: Data) async throws -> Self
}

extension DecodableModel where Self: Codable {
    static func createFrom(_ data: Data) async throws -> Self {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        
        do {
            let decoded = try decoder.decode(Self.self, from: data)
            return decoded
        } catch {
            throw NetworkRequestError.decodingError
        }
    }
}

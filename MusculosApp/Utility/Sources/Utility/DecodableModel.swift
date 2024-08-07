//
//  DecodableModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

/// Utility that decodes Data into  a Codable object
/// Supports single objects or arrays
///
public protocol DecodableModel {
  static func createFrom(_ data: Data) async throws -> Self
  static func createArrayFrom(_ data: Data) async throws -> [Self]
}

public extension DecodableModel where Self: Codable {
  public static func createFrom(_ data: Data) throws -> Self {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
      let decoded = try decoder.decode(Self.self, from: data)
      return decoded
    } catch {
      MusculosLogger.logError(error,
                              message: "Could not decode object",
                              category: .networking,
                              properties: ["object": String(describing: Self.self)])
      throw MusculosError.decodingError
    }
  }

  public static func createArrayFrom(_ data: Data) throws -> [Self] {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase

    do {
      let decoded = try decoder.decode([Self].self, from: data)
      return decoded
    } catch {
      MusculosLogger.logError(error,
                              message: "Could not decode object",
                              category: .networking,
                              properties: ["object": String(describing: Self.self)])
      throw MusculosError.decodingError
    }
  }
}

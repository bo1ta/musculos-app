//
//  DecodableModel.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

/// Utility that decodes Data into a Codable object
/// Supports single objects or arrays
///
public protocol DecodableModel: Codable {
  static func createFrom(_ data: Data) throws -> Self
  static func createArrayFrom(_ data: Data) throws -> [Self]
}

public extension DecodableModel where Self: Codable {
  public static func createFrom(_ data: Data) throws -> Self {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode(Self.self, from: data)
    } catch {
      MusculosLogger.logError(
        error,
        message: "Could not decode object",
        category: .networking,
        properties: ["object": String(describing: Self.self)]
      )
      throw error
    }
  }

  public static func createArrayFrom(_ data: Data) throws -> [Self] {
    let decoder = JSONDecoder()

    do {
      return try decoder.decode([Self].self, from: data)
    } catch {
      MusculosLogger.logError(
        error,
        message: "Could not decode object",
        category: .networking,
        properties: ["object": String(describing: Self.self)]
      )
      throw error
    }
  }
}

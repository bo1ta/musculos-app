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
public protocol DecodableModel: Codable {}

public extension DecodableModel where Self: Codable {
  public static func createFrom(_ data: Data) throws -> Self {
    do {
      return try JSONHelper.decoder.decode(Self.self, from: data)
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
    do {
      return try JSONHelper.decoder.decode([Self].self, from: data)
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

  public func toDictionary() -> [String: Any]? {
    guard let data = try? JSONHelper.encoder.encode(self) else {
      return nil
    }

    guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      return nil
    }

    return dictionary
  }
}

private class JSONHelper {
  static let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .iso8601
    return decoder
  }()

  static let encoder: JSONEncoder = {
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    return encoder
  }()
}


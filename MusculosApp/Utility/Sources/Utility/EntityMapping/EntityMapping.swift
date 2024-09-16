//
//  EntityMapping.swift
//  
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation

@propertyWrapper
public struct EntityMapping<T>: Codable where T: Codable {
    public let key: String
    public var wrappedValue: T

    public init(_ key: String) where T: ExpressibleByNilLiteral {
        self.key = key
        self.wrappedValue = T(nilLiteral: ())
    }

    public init(wrappedValue: T, _ key: String) {
        self.wrappedValue = wrappedValue
        self.key = key
    }

    public enum CodingKeys: CodingKey {
        case wrappedValue
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(wrappedValue)
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.wrappedValue = try container.decode(T.self)
        self.key = "" // this is set by the property wrapper's synthesized initializer
    }
}

extension KeyedDecodingContainer {
  func decode<T>(_ type: EntityMapping<T?>.Type, forKey key: Self.Key) throws -> EntityMapping<T?> where T: Codable {
    return try decodeIfPresent(type, forKey: key) ?? EntityMapping<T?>(wrappedValue: nil, "")
  }
}

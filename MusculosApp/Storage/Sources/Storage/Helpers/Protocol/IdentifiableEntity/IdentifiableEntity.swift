//
//  IdentifiableEntity.swift
//  Models
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation

public protocol IdentifiableEntity: Sendable {
  /// Identifier key used for Core Data predicate
  ///
  static var identifierKey: String { get }

  /// Unique identifier value
  ///
  var identifierValue: UUID { get }
}

public extension IdentifiableEntity {
  func matchingPredicate() -> NSPredicate {
    return NSPredicate(format: "%K == %@", Self.identifierKey, identifierValue as NSUUID)
  }
}

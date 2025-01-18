//
//  IdentifiableEntity.swift
//  Models
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation

// MARK: - IdentifiableEntity

public protocol IdentifiableEntity: Sendable {
  /// Identifier key used for Core Data predicate
  ///
  static var identifierKey: String { get }

  /// Unique identifier value
  ///
  var identifierValue: UUID { get }
}

extension IdentifiableEntity {
  public func matchingPredicate() -> NSPredicate {
    NSPredicate(format: "%K == %@", Self.identifierKey, identifierValue as NSUUID)
  }
}

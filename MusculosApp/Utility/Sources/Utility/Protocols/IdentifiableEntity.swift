//
//  IdentifiableEntity.swift
//  Utility
//
//  Created by Solomon Alexandru on 17.10.2024.
//

import Foundation

// MARK: - IdentifiableEntity

public protocol IdentifiableEntity: Sendable {

  /// Identifier key used for Core Data predicate
  ///
  static var identifierKey: String { get }

  /// Identifier value
  ///
  var id: UUID { get }
}

extension IdentifiableEntity {
  public static var identifierKey: String { "uniqueID" }

  public func matchingPredicate() -> NSPredicate {
    NSPredicate(format: "%K == %@", Self.identifierKey, id as NSUUID)
  }
}

//
//  ReadOnlyConvertible.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation

// MARK: - ReadOnlyConvertible

/// Helper protocol to convert core data models to a thread-safe model
///
public protocol ReadOnlyConvertible: TypeErasedReadOnlyConvertible {
  /// Represents the ReadOnly Type (mirroring the receiver).
  ///
  associatedtype ReadOnlyType

  /// Returns a ReadOnly version of the receiver.
  ///
  func toReadOnly() -> ReadOnlyType
}

// MARK: - TypeErasedReadOnlyConvertible

public protocol TypeErasedReadOnlyConvertible {
  /// Returns a ReadOnly version of the receiver, but with no Type associated.
  ///
  func toTypeErasedReadOnly() -> Any
}

extension ReadOnlyConvertible {
  public func toTypeErasedReadOnly() -> Any {
    toReadOnly()
  }
}

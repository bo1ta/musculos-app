//
//  ReadOnlyConvertible.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.03.2024.
//

import Foundation

/// Helper protocol to convert core data models to a thread-safe model
///
public protocol ReadOnlyConvertible: TypeErasedReadOnlyConvertible {

  /// Represents the ReadOnly Type (mirroring the receiver).
  ///
  associatedtype ReadOnlyType
  
  /// Updates the Receiver with the ReadOnly Instance.
  /// Optional.
  ///
  func update(from readable: ReadOnlyType)
  
  /// Returns a ReadOnly version of the receiver.
  ///
  func toReadOnly() -> ReadOnlyType
}

/// Make `update` implementation optional.
/// Using it is generally unsafe -- Core Data isn't thread-safe.
///
extension ReadOnlyConvertible {
  public func update(from readable: ReadOnlyType) { }
}

public protocol TypeErasedReadOnlyConvertible {

    /// Returns a ReadOnly version of the receiver, but with no Type associated.
    ///
    func toTypeErasedReadOnly() -> Any
}

extension ReadOnlyConvertible {
    public func toTypeErasedReadOnly() -> Any {
        return toReadOnly()
    }
}

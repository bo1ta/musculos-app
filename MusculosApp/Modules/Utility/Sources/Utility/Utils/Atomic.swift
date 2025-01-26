//
//  Atomic.swift
//  Utility
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import os

/// A thread-safe property wrapper for atomic access to a value.
/// This wrapper ensures thread-safe read and write access to the wrapped value using `OSAllocatedUnfairLock`.
///
@propertyWrapper
public final class Atomic<Value: Sendable> {
  private let lock: OSAllocatedUnfairLock<Value>

  /// Initializes the property wrapper with an initial value.
  /// - Parameters:
  ///   - initialValue: The initial value of the property
  ///
  public init(wrappedValue: Value) {
    lock = OSAllocatedUnfairLock(initialState: wrappedValue)
  }

  /// Accessor to the wrapped value.
  /// Provides atomic get and set operations
  ///
  public var wrappedValue: Value {
    get {
      lock.withLock { $0 }
    }
    set {
      lock.withLock { value in
        value = newValue
      }
    }
  }
}

//
//  Atomic.swift
//  Utility
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Foundation
import os

@propertyWrapper
public final class Atomic<Value: Sendable> {
  private let lock: OSAllocatedUnfairLock<Value>

  public init(wrappedValue: Value) {
    self.lock = OSAllocatedUnfairLock(initialState: wrappedValue)
  }

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

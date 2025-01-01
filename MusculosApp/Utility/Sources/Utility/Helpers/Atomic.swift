//
//  Atomic.swift
//  Utility
//
//  Created by Solomon Alexandru on 01.01.2025.
//

import Foundation

@propertyWrapper
public struct Atomic<Value> {
  private let queue = DispatchQueue(label: "com.utility.atomic.\(UUID().uuidString)")
  private var value: Value

  public init(wrappedValue: Value) {
    self.value = wrappedValue
  }

  public var wrappedValue: Value {
    get {
      queue.sync { value }
    }
    set {
      queue.sync { value = newValue }
    }
  }
}

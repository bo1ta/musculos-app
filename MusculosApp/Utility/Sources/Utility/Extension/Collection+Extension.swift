//
//  Collection+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 28.12.2024.
//

public extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript(safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

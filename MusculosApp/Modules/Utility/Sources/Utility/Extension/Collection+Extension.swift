//
//  Collection+Extension.swift
//  Utility
//
//  Created by Solomon Alexandru on 28.12.2024.
//

extension Collection {
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  public subscript(safe index: Index) -> Element? {
    indices.contains(index) ? self[index] : nil
  }
}

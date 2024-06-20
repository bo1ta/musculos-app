//
//  Collection+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 26.02.2024.
//

import Foundation

public extension Collection {
  /// Splits the collection into `n` subcollections
  func every(n: Int, start: Int = 0) -> UnfoldSequence<Element,Index> {
    sequence(state: dropFirst(start).startIndex) { index in
      guard index < endIndex else { return nil }
      defer { index = self.index(index, offsetBy: n, limitedBy: endIndex) ?? endIndex }
      return self[index]
    }
  }
  
  /// Returns the element at the specified index if it is within bounds, otherwise nil.
  subscript (safe index: Index) -> Element? {
    return indices.contains(index) ? self[index] : nil
  }
}

public extension RangeReplaceableCollection {
  func splitIn(subSequences n: Int) -> [SubSequence] {
    (0..<n).map { .init(every(n: n, start: $0)) }
  }
}

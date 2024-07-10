//
//  Array+Extension.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.09.2023.
//

import Foundation

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
  
  /// Combines multiple arrays without duplicates
  static func combine<T>(_ arrays: Array<T>?...) -> Set<T> {
      return arrays.compactMap{$0}.compactMap{Set($0)}.reduce(Set<T>()){$0.union($1)}
  }
}

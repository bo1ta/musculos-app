//
//  DebouncedQueryObserver.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import Foundation
import Combine

/// Helper observable object with a query subscriber
///
public class DebouncedQueryObserver: ObservableObject {
  @Published public var searchQuery: String = ""
  @Published public var debouncedQuery: String = ""

  public init(delay: Double = 0.5) {
    $searchQuery
      .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(delay), scheduler: DispatchQueue.main)
      .assign(to: &$debouncedQuery)
  }
}

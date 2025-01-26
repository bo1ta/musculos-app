//
//  DebouncedQueryObserver.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 09.02.2024.
//

import Combine
import Foundation

/// Helper observable object with a query subscriber
///
public class DebouncedQueryObserver: ObservableObject {
  @Published public var searchQuery = ""
  @Published public var debouncedQuery = ""

  public init(delay: Double = 0.5) {
    $searchQuery
      .debounce(for: DispatchQueue.SchedulerTimeType.Stride.seconds(delay), scheduler: DispatchQueue.main)
      .assign(to: &$debouncedQuery)
  }
}

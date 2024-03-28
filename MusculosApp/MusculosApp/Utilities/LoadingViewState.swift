//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum LoadingViewState<T> where T: Equatable {
  case loading
  case loaded(T)
  case empty
  case error(String)
}

extension LoadingViewState: Equatable {
  static func == (lhs: LoadingViewState<T>, rhs: LoadingViewState<T>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.empty, .empty):
      return true
    case (.error(let lhsMessage), .error(let rhsMessage)):
      return lhsMessage == rhsMessage
    case (.loaded(let lhsData), .loaded(let rhsData)):
      return lhsData == rhsData
    default:
      return false
    }
  }
}

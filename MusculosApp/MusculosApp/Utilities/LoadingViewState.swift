//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

enum LoadingViewState<Result> where Result: Equatable {
  case loading
  case loaded(Result)
  case empty
  case error(String)
}

extension LoadingViewState: Equatable {
  static func == (lhs: LoadingViewState<Result>, rhs: LoadingViewState<Result>) -> Bool {
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

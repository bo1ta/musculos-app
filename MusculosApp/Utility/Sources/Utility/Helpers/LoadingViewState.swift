//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

public enum LoadingViewState<Result> where Result: Equatable {
  case loading
  case loaded(Result)
  case empty
  case error(String)
}

extension LoadingViewState: Equatable {
  public static func == (lhs: LoadingViewState<Result>, rhs: LoadingViewState<Result>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      return true
    case (.empty, .empty):
      return true
    case let (.error(lhsMessage), .error(rhsMessage)):
      return lhsMessage == rhsMessage
    case let (.loaded(lhsData), .loaded(rhsData)):
      return lhsData == rhsData
    default:
      return false
    }
  }
}

public enum EmptyLoadingViewState {
  case loading, empty, successful
}

//
//  LoadingViewState.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 20.02.2024.
//

import Foundation

// MARK: - LoadingViewState

public enum LoadingViewState<Result> where Result: Equatable {
  case loading
  case loaded(Result)
  case empty
  case error(String)
}

// MARK: Equatable

extension LoadingViewState: Equatable {
  public static func ==(lhs: LoadingViewState<Result>, rhs: LoadingViewState<Result>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      true
    case (.empty, .empty):
      true
    case (.error(let lhsMessage), .error(let rhsMessage)):
      lhsMessage == rhsMessage
    case (.loaded(let lhsData), .loaded(let rhsData)):
      lhsData == rhsData
    default:
      false
    }
  }
}

// MARK: - EmptyLoadingViewState

public enum EmptyLoadingViewState {
  case loading, empty, successful
}

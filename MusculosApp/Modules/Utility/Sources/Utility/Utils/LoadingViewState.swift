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
  case error(Error)

  /// A mutating method that transitions from `.loading` to either `.loaded` or `.empty`
  /// based on whether the provided result is empty or not.
  /// - Parameter result: The result to be assigned.
  ///
  public mutating func assignResult(_ result: Result) where Result: Collection {
    if result.isEmpty {
      self = .empty
    } else {
      self = .loaded(result)
    }
  }

  /// A mutating method that transitions from `.loading` to either `.loaded` or `.empty`
  /// based on whether the provided result is nil or not.
  /// - Parameter result: The result to be assigned.
  ///
  public mutating func assignResult(_ result: Result?) {
    if let result {
      self = .loaded(result)
    } else {
      self = .empty
    }
  }

  /// Assigns the provided error to the `.error` state, unless the current state is `.loaded`.
  /// This method is useful in scenarios where errors may be logged and discarded,
  /// especially in streams where a previous "success" state might have occurred.
  ///
  /// - Parameter error: The error to assign to the `.error` state.
  ///
  public mutating func assignErrorIfNotLoaded(_ error: Error) {
    switch self {
    case .loaded:
      return
    default:
      self = .error(error)
    }
  }

  /// Checks if the state is `loadable`.
  /// For cases like `empty` it should always be loadable.
  /// For cases like `error` it depends if the error is retryable or was previously cancelled.
  ///
  public var isLoadable: Bool {
    switch self {
    case .empty:
      true
    case .error(let error):
      isRetryableError(error)
    case .loaded, .loading:
      false
    }
  }

  /// Checks if the error is retryable.
  ///
  private func isRetryableError(_ error: Error) -> Bool {
    MusculosError.isRetryableError(error)
      || error is CancellationError
      || (error as? URLError)?.code == .cancelled
  }

  /// Returns the underlying result if the state is `.loaded`, or nil if the state is
  ///  `.loading`, `.emoty` or `.error`.
  ///
  /// - Returns: The result if loaded, or nil otherwise
  ///
  public func resultOrNil() -> Result? {
    switch self {
    case .loaded(let result):
      result
    default:
      nil
    }
  }

  /// Returns the underlying result if the state is `.loaded`, or an empty list if the state is
  /// `.loading`, `.empty`, or `.error`.
  ///
  /// - Returns: The result if loaded, or an empty list otherwise.
  ///
  public func resultsOrEmpty() -> Result where Result: Collection, Result: ExpressibleByArrayLiteral {
    switch self {
    case .loaded(let result):
      result
    default:
      [] as Result
    }
  }
}

// MARK: Equatable

extension LoadingViewState: Equatable {
  public static func ==(lhs: LoadingViewState<Result>, rhs: LoadingViewState<Result>) -> Bool {
    switch (lhs, rhs) {
    case (.loading, .loading):
      true
    case (.empty, .empty):
      true
    case (.error(let lhsError), .error(let rhsError)):
      lhsError.localizedDescription == rhsError.localizedDescription
    case (.loaded(let lhsData), .loaded(let rhsData)):
      lhsData == rhsData
    default:
      false
    }
  }
}

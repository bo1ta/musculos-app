//
//  UIState.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Foundation

// MARK: - UIState

public enum UIState {
  case idle
  case loading
  case error(Error)
}

// MARK: Equatable

extension UIState: Equatable {
  public static func ==(lhs: UIState, rhs: UIState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      true
    case (.loading, .loading):
      true
    case (.error(let error1), .error(let error2)):
      error1.localizedDescription == error2.localizedDescription
    default:
      false
    }
  }
}

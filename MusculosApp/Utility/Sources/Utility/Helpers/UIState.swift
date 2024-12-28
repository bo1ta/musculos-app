//
//  UIState.swift
//
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Foundation

public enum UIState {
  case idle
  case loading
  case error(Error)
}

extension UIState: Equatable {
  public static func == (lhs: UIState, rhs: UIState) -> Bool {
    switch (lhs, rhs) {
    case (.idle, .idle):
      return true
    case (.loading, .loading):
      return true
    case let (.error(error1), .error(error2)):
      return error1.localizedDescription == error2.localizedDescription
    default:
      return false
    }
  }
}

//
//  SynchronizationState.swift
//  
//
//  Created by Solomon Alexandru on 15.07.2024.
//

import Foundation

public enum SynchronizationState: Int {
  case notSynchronized = 0
  case synchronized = 1
  case error = 2

  func asNSNumber() -> NSNumber {
    return NSNumber(integerLiteral: rawValue)
  }
}

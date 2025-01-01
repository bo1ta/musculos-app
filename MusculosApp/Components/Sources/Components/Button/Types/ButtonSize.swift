//
//  ButtonSize.swift
//  Components
//
//  Created by Solomon Alexandru on 05.10.2024.
//

import Foundation

public enum ButtonSize {
  case small
  case medium
  case large

  public var labelPadding: CGFloat {
    switch self {
    case .small: 10
    case .medium: 13
    case .large: 17
    }
  }
}

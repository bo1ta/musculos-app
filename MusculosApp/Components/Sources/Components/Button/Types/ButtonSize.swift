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
    case .small: return 10
    case .medium: return 13
    case .large: return 17
    }
  }
}

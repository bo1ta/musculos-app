//
//  CalendarMarker.swift
//  Components
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Foundation
import SwiftUI

// MARK: - CalendarMarker

public struct CalendarMarker: Identifiable {
  public let id = UUID()
  public let date: Date
  public let color: Color

  public init(date: Date, color: Color) {
    self.date = date
    self.color = color
  }
}

// MARK: Equatable

extension CalendarMarker: Equatable {
  public static func ==(_ lhs: CalendarMarker, rhs: CalendarMarker) -> Bool {
    lhs.id == rhs.id
  }
}

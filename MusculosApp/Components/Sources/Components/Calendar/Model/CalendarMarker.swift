//
//  CalendarMarker.swift
//  Components
//
//  Created by Solomon Alexandru on 24.11.2024.
//

import Foundation
import SwiftUI

public struct CalendarMarker: Identifiable {
  public let id = UUID()
  public let date: Date
  public let color: Color

  public init(date: Date, color: Color) {
    self.date = date
    self.color = color
  }
}

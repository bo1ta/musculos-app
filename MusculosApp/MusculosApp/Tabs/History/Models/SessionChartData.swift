//
//  SessionChartData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Foundation

// MARK: - SessionChartData

struct SessionChartData: Identifiable {
  var id: UUID
  var dayName: String
  var count: Int

  init(id: UUID = UUID(), dayName: String, count: Int) {
    self.id = id
    self.dayName = dayName
    self.count = count
  }
}

// MARK: Equatable

extension SessionChartData: Equatable {
  static func ==(_ lhs: SessionChartData, rhs: SessionChartData) -> Bool {
    lhs.id == rhs.id
  }
}

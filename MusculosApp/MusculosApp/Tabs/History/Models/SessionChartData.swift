//
//  SessionChartData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Foundation

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

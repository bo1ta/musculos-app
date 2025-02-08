//
//  MuscleChartData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Foundation

struct MuscleChartData: Identifiable {
  var id: UUID
  var muscleName: String
  var count: Int

  init(id: UUID = UUID(), muscle: String, count: Int) {
    self.id = id
    self.muscleName = muscle
    self.count = count
  }
}

//
//  MuscleChartData.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 08.02.2025.
//

import Foundation

// MARK: - MuscleChartData

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

// MARK: Equatable

extension MuscleChartData: Equatable {
  static func ==(_ lhs: MuscleChartData, rhs: MuscleChartData) -> Bool {
    lhs.id == rhs.id
  }
}

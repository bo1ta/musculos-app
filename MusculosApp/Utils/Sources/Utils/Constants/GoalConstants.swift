//
//  GoalConstants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation

struct GoalConstants {
  static let categoryOptions = Goal.Category.allCases.map { $0.label }
  static let frequencyOptions = Goal.Frequency.allCases.map { $0.description }
}

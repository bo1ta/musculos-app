//
//  GoalConstants.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.05.2024.
//

import Foundation

public enum GoalConstants {
  public static let categoryOptions = Goal.Category.allCases.map { $0.label }
  public static let frequencyOptions = Goal.Frequency.allCases.map { $0.description }
}

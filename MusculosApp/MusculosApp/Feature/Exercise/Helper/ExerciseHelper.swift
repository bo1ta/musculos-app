//
//  ExerciseHelper.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 21.06.2024.
//

import Foundation

struct ExerciseHelper {
  static let goalToExerciseCategories: [Goal.Category: [String]] = [
    .growMuscle: [
      ExerciseConstants.CategoryType.strength.rawValue,
      ExerciseConstants.CategoryType.powerlifting.rawValue,
      ExerciseConstants.CategoryType.strongman.rawValue,
      ExerciseConstants.CategoryType.olympicWeightlifting.rawValue
    ],
    .loseWeight: [
      ExerciseConstants.CategoryType.cardio.rawValue,
      ExerciseConstants.CategoryType.stretching.rawValue
    ]
  ]
}

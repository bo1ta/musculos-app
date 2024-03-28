//
//  ExerciseProvider.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 28.02.2024.
//

import Foundation

protocol ExerciseProvider {
  var name: String { get set }
  var category: String { get set }
  var level: String { get set }
  var instructions: [String] { get set }
  var isFavorite: Bool { get set }
  var imageUrls: [String] { get set }
  var force: String? { get set }
  var equipment: String? { get set }
  var primaryMuscles: [String] { get set }
  var secondaryMuscles: [String] { get set }
}

extension ExerciseProvider {
  var isFavorite: Bool {
    return false
  }
}


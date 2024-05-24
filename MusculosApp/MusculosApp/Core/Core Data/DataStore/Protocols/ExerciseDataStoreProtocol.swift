//
//  ExerciseDataStoreProtocol.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 22.05.2024.
//

import Foundation

protocol ExerciseDataStoreProtocol {
  // read methods
  func isFavorite(_ exercise: Exercise) -> Bool
  func getAll() -> [Exercise]
  func getByName(_ name: String) -> [Exercise]
  func getByMuscles(_ muscles: [MuscleType]) -> [Exercise]
  
  // write methods
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async
  func importFrom(_ exercises: [Exercise]) async -> [Exercise]
  func add(_ exercise: Exercise) async
}

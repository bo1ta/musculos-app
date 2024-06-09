//
//  StubExerciseDataStore.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

@testable import MusculosApp

class StubExerciseDataStore: ExerciseDataStoreProtocol {
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise] {
    return exercises
  }
  
  func isFavorite(_ exercise: Exercise) async -> Bool {
    return false
  }
  
  func getAll() async -> [Exercise] {
    return []
  }
  
  func getByName(_ name: String) async -> [Exercise] {
    return []
  }
  
  func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return []
  }
  
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {}
  
  func add(_ exercise: Exercise) async throws {}
}

//
//  StubExerciseDataStore.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation

@testable import MusculosApp

class StubExerciseDataStore: ExerciseDataStoreProtocol {
  var expectedExercises: [Exercise] = []
  
  func getAll(fetchLimit: Int) async -> [Exercise] {
    return expectedExercises
  }
  
  func getAllFavorites() async -> [Exercise] {
    return expectedExercises
  }
  
  func importFrom(_ exercises: [Exercise]) async throws -> [Exercise] {
    return exercises
  }
  
  func isFavorite(_ exercise: Exercise) async -> Bool {
    return false
  }
  
  func getByName(_ name: String) async -> [Exercise] {
    return expectedExercises
  }
  
  func getByMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return expectedExercises
  }
  
  func getAllByGoals(_ goals: [Goal], fetchLimit: Int) async -> [Exercise] {
    return expectedExercises
  }
  
  func getAllExcludingMuscles(_ muscles: [MuscleType]) async -> [Exercise] {
    return expectedExercises
  }
  
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {}
  
  func add(_ exercise: Exercise) async throws {}
  
}

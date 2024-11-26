//
//  StubExerciseDataStore.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 09.06.2024.
//

import Foundation
import Models
import Storage
import Utility

@testable import MusculosApp

final class StubExerciseDataStore: ExerciseDataStoreProtocol, @unchecked Sendable {
  var expectedExercises: [Exercise] = []
  var shouldFail: Bool = false

  func getAll(fetchLimit: Int) async -> [Exercise] {
    return expectedExercises
  }
  
  func getAllFavorites() async -> [Exercise] {
    return expectedExercises
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
  
  func setIsFavorite(_ exercise: Exercise, isFavorite: Bool) async throws {
    if shouldFail {
      throw MusculosError.notFound
    }
  }
  
  func add(_ exercise: Exercise) async throws {}

  func getByID(_ exerciseID: UUID) async -> Models.Exercise? {
    return expectedExercises.first ?? nil
  }

  func getCount() async -> Int {
    return expectedExercises.count
  }

  func getByMuscle(_ muscle: MuscleType) async -> [Exercise] {
    return expectedExercises
  }

  func getByMuscleGroup(_ muscleGroup: MuscleGroup) async -> [Exercise] {
    return expectedExercises
  }

  func importExercises(_ exercises: [Exercise]) async throws {}
}

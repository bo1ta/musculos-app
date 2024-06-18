//
//  ExerciseDataStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 10.05.2024.
//

import Foundation
import XCTest
import Factory

@testable import MusculosApp

final class ExerciseDataStoreTests: XCTestCase, MusculosTestBase {
  func testMarkAndCheckAsFavorite() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString)
    try await self.populateStorageWithExercise(exercise: exercise)
    
    let dataStore = ExerciseDataStore()
    
    /// Mark as favorite
    try await dataStore.setIsFavorite(exercise, isFavorite: true)
    
    /// Check is favorite
    let isFavorite = await dataStore.isFavorite(exercise)
    XCTAssertTrue(isFavorite)
  }
  
  func testGetAll() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString)
    try await self.populateStorageWithExercise(exercise: exercise)
    
    let dataStore = ExerciseDataStore()
    let results = await dataStore.getAll()
    XCTAssertFalse(results.isEmpty)
  }
  
  func testGetByName() async throws {
    let exerciseName = "Best Exercise"
    
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: exerciseName)
    try await self.populateStorageWithExercise(exercise: exercise)
    
    let dataStore = ExerciseDataStore()
    let results = await dataStore.getByName(exerciseName)
    XCTAssertEqual(results.count, 1)
    
    let first = try XCTUnwrap(results.first)
    XCTAssertEqual(first.id, exercise.id)
  }
  
//  func testGetByMuscles() async throws {
//    let muscles: [MuscleType] = [.biceps, .chest]
//    let musclesStrings = muscles.map { $0.rawValue }
//    
//    let exercise = ExerciseFactory.createExercise(
//      uuidString: UUID().uuidString,
//      primaryMuscles: musclesStrings
//    )
//    try await self.populateStorageWithExercise(exercise: exercise)
//    
//    let dataStore = ExerciseDataStore()
//    let results = await dataStore.getByMuscles(muscles)
//    XCTAssertFalse(results.isEmpty)
//  }
//  
//  func testGetAllExcludingMuscles() async throws {
//    let muscles: [MuscleType] = [.biceps, .chest]
//    let musclesStrings = muscles.map { $0.rawValue }
//    
//    let exercise = ExerciseFactory.createExercise(
//      uuidString: UUID().uuidString,
//      primaryMuscles: musclesStrings
//    )
//    try await self.populateStorageWithExercise(exercise: exercise)
//    
//    let dataStore = ExerciseDataStore()
//    let results = await dataStore.getByMuscles(muscles)
//    XCTAssertTrue(results.isEmpty)
//  }
  
  func testGetAllByGoals() async throws {
    let goal = Goal(name: "Grow muscles", category: .growMuscle, frequency: .daily, targetValue: "10", endDate: Date())
    
    let exercise = ExerciseFactory.createExercise(
      uuidString: UUID().uuidString,
      category: ExerciseConstants.CategoryType.strength.rawValue
    )
    try await self.populateStorageWithExercise(exercise: exercise)
    
    let dataStore = ExerciseDataStore()
    let results = await dataStore.getAllByGoals([goal], fetchLimit: 10)
    XCTAssertFalse(results.isEmpty)
  }
}

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
  override func tearDown() {
    Container.shared.storageManager().reset()
    super.tearDown()
  }
  
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
}

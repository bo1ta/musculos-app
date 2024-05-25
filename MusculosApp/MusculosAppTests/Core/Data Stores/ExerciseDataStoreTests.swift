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
  var hasPopulatedStorage: Bool = false
  
  override class func setUp() {
    super.setUp()
    Container.shared.storageManager.register { DummyStack() }
  }
  
  override class func tearDown() {
    Container.shared.storageManager.reset()
    super.tearDown()
  }
  
  func testMarkAndCheckAsFavorite() async throws {
    let mockExercise = ExerciseFactory.createExercise()
    await self.populateStorageWithMockExercise(exercise: mockExercise)
    
    let dataStore = ExerciseDataStore()
    
    /// Mark as favorite
    await dataStore.setIsFavorite(mockExercise, isFavorite: true)
    
    /// Check is favorite
    let isFavorite = await dataStore.isFavorite(mockExercise)
    XCTAssertTrue(isFavorite)
  }
}

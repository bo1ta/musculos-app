//
//  ExerciseStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp
import Factory

final class ExerciseStoreTests: XCTestCase, MusculosTestBase {
  var hasPopulatedStorage = false
  
  func testInitialValues() {
    let store = ExerciseStore()
    XCTAssertEqual(store.state, .empty)
    XCTAssertNil(store.exerciseTask)
    XCTAssertNil(store.searchTask)
    XCTAssertNil(store.favoriteTask)
  }
  
  func testLoadRemoteExercies() async throws {
    let data = try self.readFromFile(name: "getExercises")
    let expectedResults = try Exercise.createArrayFrom(data)
    let expectation = self.expectation(description: "should load exercises")
    
    let mockModule = MockExerciseModule()
    mockModule.expectation = expectation
    mockModule.expectedResults = expectedResults
    
    let store = ExerciseStore(module: mockModule)
    XCTAssertEqual(store.state, .empty)
    
    store.loadRemoteExercises()
    
    let task = try XCTUnwrap(store.exerciseTask)
    await task.value
    await fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(store.state, .loaded(expectedResults))
  }
  
  func testLoadRemoteExerciseFails() async throws {
    let data = try self.readFromFile(name: "getExercises")
    let expectedResults = try Exercise.createArrayFrom(data)
    let expectation = self.expectation(description: "should try to load exercises")
    
    let mockModule = MockExerciseModule()
    mockModule.expectation = expectation
    mockModule.expectedResults = expectedResults
    mockModule.shouldFail = true
    
    let store = ExerciseStore(module: mockModule)
    XCTAssertEqual(store.state, .empty)
    
    store.loadRemoteExercises()
    
    let task = try XCTUnwrap(store.exerciseTask)
    await task.value
    await fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(store.state, .error(MessageConstant.genericErrorMessage.rawValue))
  }
  
  func testSearchByMuscleQuery() async throws {
    let data = try self.readFromFile(name: "getExercises")
    let expectedResults = try Exercise.createArrayFrom(data)
    let expectation = self.expectation(description: "should search by muscle query")
    
    let mockModule = MockExerciseModule()
    mockModule.expectation = expectation
    mockModule.expectedResults = expectedResults
    
    let store = ExerciseStore(module: mockModule)
    XCTAssertNil(store.searchTask)
    XCTAssertEqual(store.state, .empty)
    
    store.searchByMuscleQuery("muscle")
    
    let searchTask = try XCTUnwrap(store.searchTask)
    await searchTask.value
    await fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(store.state, .loaded(expectedResults))
  }
}

// MARK: - Core Data Tests

extension ExerciseStoreTests {
  func testFetchedControllerLoadsLocalExercises() async throws {
    let expectedExercise = ExerciseFactory.createExercise()
    
    /// Populate core data store
    try await self.populateStorageWithExercise()
  
    let store = ExerciseStore(module: MockExerciseModule())
    await store.updateLocalResults()
    
    print(store.storedExercises.count)
    XCTAssertTrue(store.storedExercises.count > 0)
  }
  
  func testFavoriteExercise() async throws {
    /// Populate core data store
    try await self.populateStorageWithExercise()
    
    let store = ExerciseStore(module: MockExerciseModule())
    await store.updateLocalResults()
    
    let firstExercise = try XCTUnwrap(store.storedExercises.first)
    var isFavorite = await store.checkIsFavorite(exercise: firstExercise)
    XCTAssertFalse(isFavorite)
    XCTAssertNil(store.favoriteTask)
    
    store.favoriteExercise(firstExercise, isFavorite: true)
    
    let favoriteTask = try XCTUnwrap(store.favoriteTask)
    await favoriteTask.value
    
    isFavorite = await store.checkIsFavorite(exercise: firstExercise)
    XCTAssertTrue(isFavorite)
  }
}

// MARK: - Helpers

extension ExerciseStoreTests {
  private class MockExerciseModule: ExerciseModuleProtocol {
    var expectation: XCTestExpectation?
    var shouldFail: Bool = false
    
    var dataStore: ExerciseDataStoreProtocol
    
    init(dataStore: ExerciseDataStoreProtocol = ExerciseDataStore()) {
      self.dataStore = dataStore
    }
    
    var expectedResults: [Exercise] = []
    func getExercises() async throws -> [Exercise] {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResults
    }
    
    func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResults
    }
  }
}

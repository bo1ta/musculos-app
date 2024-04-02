//
//  ExerciseStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class ExerciseStoreTests: XCTestCase, MusculosTestBase {
  override class func setUp() {
    CoreDataStack.setOverride(DummyStack())
  }
  
  override class func tearDown() {
    CoreDataStack.resetOverride()
    super.tearDown()
  }
  
  func testInitialValues() {
    let store = ExerciseStore()
    XCTAssertEqual(store.state, .loaded([]))
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
    store.loadRemoteExercises()
    
    let task = try XCTUnwrap(store.exerciseTask)
    await task.value
    await fulfillment(of: [expectation], timeout: 1)
    
    XCTAssertEqual(store.state, .loaded(expectedResults))
  }
  
  func testFetchedControllerLoadsLocalExercises() async throws {
    /// Populate core data store
    await populateStorageWithMockData()
  
    let store = ExerciseStore(module: MockExerciseModule())
    guard case let LoadingViewState.loaded(exercises) = store.state, let storedExercise = exercises.first else {
      XCTFail("Should find exercise")
      return
    }

    let mockExercise = ExerciseFactory.createExercise()
    XCTAssertEqual(storedExercise.category, mockExercise.category)
    XCTAssertEqual(storedExercise.name, mockExercise.name)
  }
}

// MARK: - Helpers

extension ExerciseStoreTests {
  
  private func populateStorageWithMockData() async {
    let context = CoreDataStack.shared.viewStorage
    await context.perform {
      let entity = context.insertNewObject(ofType: ExerciseEntity.self)
      
      let exercise = ExerciseFactory.createExercise()
      entity.exerciseId = exercise.id
      entity.name = exercise.name
      entity.category = exercise.category
      entity.instructions = exercise.instructions
      entity.equipment = exercise.equipment
      entity.instructions = exercise.instructions
      entity.imageUrls = exercise.imageUrls
      entity.primaryMuscles = exercise.primaryMuscles
      entity.secondaryMuscles = exercise.secondaryMuscles
      entity.level = exercise.level
    }
  }
  
  private class MockExerciseModule: ExerciseModuleProtocol, @unchecked Sendable {
    var expectation: XCTestExpectation?
    var shouldFail: Bool = false
    var expectedResults: [Exercise] = []
    
    var dataStore: ExerciseDataStore
    
    init(dataStore: ExerciseDataStore = ExerciseDataStore()) {
      self.dataStore = dataStore
    }
    
    func getExercises() async throws -> [Exercise] {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResults
    }
    
    func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
      return expectedResults
    }
  }
}

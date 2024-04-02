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
    let store = ExerciseStore(shouldLoadFromCache: false)
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
    
    let store = ExerciseStore(module: mockModule, shouldLoadFromCache: false)
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
    
    let store = ExerciseStore(module: mockModule, shouldLoadFromCache: false)
    XCTAssertEqual(store.state, .empty)
    
    store.loadRemoteExercises()
    
    let task = try XCTUnwrap(store.exerciseTask)
    await task.value
    await fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(store.state, .error(MessageConstant.genericErrorMessage.rawValue))
  }
  
  func testFetchedControllerLoadsLocalExercises() async throws {
    /// Populate core data store
    await populateStorageWithMockData()
  
    /// initial loads from cache
    let store = ExerciseStore(module: MockExerciseModule(), shouldLoadFromCache: true)
    guard case let LoadingViewState.loaded(exercises) = store.state, let storedExercise = exercises.first else {
      XCTFail("Should find exercise")
      return
    }

    let mockExercise = ExerciseFactory.createExercise()
    XCTAssertEqual(storedExercise.category, mockExercise.category)
    XCTAssertEqual(storedExercise.name, mockExercise.name)
  }
  
  func testFavoriteExercise() async throws {
    /// Populate core data store
    await populateStorageWithMockData()
    
    let store = ExerciseStore(module: MockExerciseModule(), shouldLoadFromCache: true)
    guard case let LoadingViewState.loaded(exercises) = store.state, let exercise = exercises.first else {
      XCTFail("Should find exercise")
      return
    }
    
    var isFavorite = await store.checkIsFavorite(exercise: exercise)
    XCTAssertFalse(isFavorite)
    XCTAssertNil(store.favoriteTask)
    
    store.favoriteExercise(exercise, isFavorite: true)
    
    let favoriteTask = try XCTUnwrap(store.favoriteTask)
    await favoriteTask.value
    
    isFavorite = await store.checkIsFavorite(exercise: exercise)
    XCTAssertTrue(isFavorite)
  }
  
  func testSearchByMuscleQuery() async throws {
    let data = try self.readFromFile(name: "getExercises")
    let expectedResults = try Exercise.createArrayFrom(data)
    let expectation = self.expectation(description: "should search by muscle query")
    
    let mockModule = MockExerciseModule()
    mockModule.expectation = expectation
    mockModule.expectedResults = expectedResults
    
    let store = ExerciseStore(module: mockModule, shouldLoadFromCache: false)
    XCTAssertNil(store.searchTask)
    XCTAssertEqual(store.state, .empty)
    
    store.searchByMuscleQuery("muscle")
    
    let searchTask = try XCTUnwrap(store.searchTask)
    await searchTask.value
    await fulfillment(of: [expectation], timeout: 1)
    XCTAssertEqual(store.state, .loaded(expectedResults))
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
  
  private class MockExerciseModule: ExerciseModuleProtocol {
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
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResults
    }
  }
}

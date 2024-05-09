//
//  ExerciseStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class ExerciseStoreTests: XCTestCase, MusculosTestBase {
  /// since multiple tests need persistent data, we don't want to populate the db more than once
  private var hasPopulatedStorage = false
  
  override class func setUp() {
    CoreDataStack.setOverride(DummyStack())
  }
  
  override class func tearDown() {
    CoreDataStack.resetOverride()
    super.tearDown()
  }
  
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

/// Tests that involve Core Data reading should run on the main thread
/// since `Fetched Results Controller`'s context is a view context
///
extension ExerciseStoreTests {
  
  @MainActor
  func testFetchedControllerLoadsLocalExercises() async throws {
    let expectedExercise = ExerciseFactory.createExercise()
    
    /// Populate core data store
    await populateStorageWithMockData()
  
    let store = ExerciseStore(module: MockExerciseModule())
    store.updateLocalResults()
    
    let firstExercise = try XCTUnwrap(store.storedExercises.first)

    
    XCTAssertEqual(firstExercise.category, expectedExercise.category)
    XCTAssertEqual(firstExercise.name, expectedExercise.name)
  }
  
  @MainActor
  func testFavoriteExercise() async throws {
    /// Populate core data store
    await populateStorageWithMockData()
    
    let store = ExerciseStore(module: MockExerciseModule())
    store.updateLocalResults()
    
    var firstExercise = try XCTUnwrap(store.storedExercises.first)
    var isFavorite = store.checkIsFavorite(exercise: firstExercise)
    XCTAssertFalse(isFavorite)
    XCTAssertNil(store.favoriteTask)
    
    store.favoriteExercise(firstExercise, isFavorite: true)
    
    let favoriteTask = try XCTUnwrap(store.favoriteTask)
    await favoriteTask.value
    
    isFavorite = store.checkIsFavorite(exercise: firstExercise)
    XCTAssertTrue(isFavorite)
  }
}

// MARK: - Helpers

extension ExerciseStoreTests {
  private func populateStorageWithMockData() async {
    guard !hasPopulatedStorage else { return }
    
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
      entity.level = exercise.level
      entity.primaryMuscles = Set<PrimaryMuscleEntity>()
      entity.secondaryMuscles = Set<SecondaryMuscleEntity>()
      
      let primaryMuscle = context.insertNewObject(ofType: PrimaryMuscleEntity.self)
      primaryMuscle.muscleId = NSNumber(integerLiteral: MuscleType.chest.id)
      primaryMuscle.name = MuscleType.chest.rawValue
      
      let secondaryMuscle = context.insertNewObject(ofType: SecondaryMuscleEntity.self)
      secondaryMuscle.muscleId = NSNumber(integerLiteral: MuscleType.biceps.id)
      secondaryMuscle.name = MuscleType.biceps.rawValue
      
      entity.primaryMuscles.insert(primaryMuscle)
      entity.secondaryMuscles.insert(secondaryMuscle)
    }
    
    hasPopulatedStorage = true
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

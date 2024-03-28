//
//  ExerciseStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class ExerciseStoreTests: XCTestCase, MusculosTestBase {
  func testInitialValues() {
    let store = ExerciseStore()
    XCTAssertEqual(store.state, .empty)
    XCTAssertNil(store.exerciseTask)
    XCTAssertNil(store.searchTask)
    XCTAssertNil(store.favoriteTask)
  }
  
  func testLoadRemoteExercies() throws {
    let data = try self.readFromFile(name: "getExercises")
    let expectedResults = try Exercise.createArrayFrom(data)
    let expectation = self.expectation(description: "should load exercises")
    
    let mockModule = MockExerciseModule()
    mockModule.expectation = expectation
    mockModule.expectedResults = expectedResults
  }
}

extension ExerciseStoreTests {
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
      return expectedResults
    }
  }
}

//
//  ExerciseStoreTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class ExerciseStoreTests: XCTestCase {

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

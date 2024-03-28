//
//  AuthViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class AuthViewModelTests: XCTestCase {
  func testInitialValues() {
    let viewModel = AuthViewModel()
    
    XCTAssertEqual(viewModel.email, "")
    XCTAssertEqual(viewModel.password, "")
    XCTAssertEqual(viewModel.fullName, "")
    XCTAssertEqual(viewModel.username, "")
    
    XCTAssertFalse(viewModel.showRegister)
    XCTAssertFalse(viewModel.isLoading)
    XCTAssertFalse(viewModel.isLoggedIn)
    
    XCTAssertNil(viewModel.errorMessage)
  }
  
  func testSignIn() {
  }
}

/// MARK: - Mocks
///
extension AuthViewModelTests {
  private class MockExerciseModule: ExerciseModuleProtocol {
    var expectation: XCTestExpectation?
    var expectedResults: [Exercise] = []
    
    var dataStore: ExerciseDataStore
    
    init(dataStore: ExerciseDataStore) {
      self.dataStore = dataStore
    }
    
    func getExercises() async throws -> [Exercise] {
      return expectedResults
    }
    
    func searchByMuscleQuery(_ query: String) async throws -> [Exercise] {
      return expectedResults
    }
  }
}

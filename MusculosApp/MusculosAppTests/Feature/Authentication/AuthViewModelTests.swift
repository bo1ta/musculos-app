//
//  AuthViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
@testable import MusculosApp

final class AuthViewModelTests: XCTestCase, MusculosTestBase {
  func testInitialValues() {
    let viewModel = AuthViewModel()
    XCTAssertEqual(viewModel.state, .empty)
    XCTAssertEqual(viewModel.email, "")
    XCTAssertEqual(viewModel.password, "")
    XCTAssertEqual(viewModel.fullName, "")
    XCTAssertEqual(viewModel.username, "")
    XCTAssertFalse(viewModel.showRegister)
  }
  
  func testSignIn() async throws {
    let shouldSignInExpectation = self.expectation(description: "should sign in")
    
    let mockService = MockAuthService(dataStore: MockDataStore())
    mockService.expectation = shouldSignInExpectation
    
    let viewModel = AuthViewModel(service: mockService)
    XCTAssertNil(viewModel.authTask)
    XCTAssertEqual(viewModel.state, .empty)
    
    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.signIn()
    await fulfillment(of: [shouldSignInExpectation], timeout: 1)
    
    let authTask = try XCTUnwrap(viewModel.authTask)
    await authTask.value
    XCTAssertEqual(viewModel.state, .loaded(true))
  }
  
  func testSignInFails() async throws {
    let shouldSignInExpectation = self.expectation(description: "should try to sign in")
    
    let mockService = MockAuthService(dataStore: MockDataStore())
    mockService.expectation = shouldSignInExpectation
    mockService.shouldFail = true
    
    let viewModel = AuthViewModel(service: mockService)
    XCTAssertNil(viewModel.authTask)
    XCTAssertEqual(viewModel.state, .empty)
    
    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.signIn()
    await fulfillment(of: [shouldSignInExpectation], timeout: 1)
    
    let authTask = try XCTUnwrap(viewModel.authTask)
    await authTask.value
    XCTAssertEqual(viewModel.state, .error(MessageConstant.genericErrorMessage.rawValue))
  }
  
  func testSignUp() async throws {
    let shouldSignUpExpectation = self.expectation(description: "should sign up")
    
    let mockService = MockAuthService(dataStore: MockDataStore())
    mockService.expectation = shouldSignUpExpectation
    
    let viewModel = AuthViewModel(service: mockService)
    XCTAssertNil(viewModel.authTask)
    XCTAssertEqual(viewModel.state, .empty)
    
    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.fullName = "John Doe"
    viewModel.username = "john.doe"
    viewModel.signUp()
    await fulfillment(of: [shouldSignUpExpectation], timeout: 1)
    
    let authTask = try XCTUnwrap(viewModel.authTask)
    await authTask.value
    XCTAssertEqual(viewModel.state, .loaded(true))
  }
  
  func testSignUpFails() async throws {
    let shouldSignUpExpectation = self.expectation(description: "should try to sign up")
    
    let mockService = MockAuthService(dataStore: MockDataStore())
    mockService.expectation = shouldSignUpExpectation
    mockService.shouldFail = true
    
    let viewModel = AuthViewModel(service: mockService)
    XCTAssertNil(viewModel.authTask)
    XCTAssertEqual(viewModel.state, .empty)
    
    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.fullName = "John Doe"
    viewModel.username = "john.doe"
    viewModel.signUp()
    await fulfillment(of: [shouldSignUpExpectation], timeout: 1)
    
    let authTask = try XCTUnwrap(viewModel.authTask)
    await authTask.value
    XCTAssertEqual(viewModel.state, .error(MessageConstant.genericErrorMessage.rawValue))
  }
}

/// MARK: - Mocks
///
extension AuthViewModelTests {
  class MockDataStore: UserDataStoreProtocol {
    var updateUserExpectation: XCTestExpectation?
    func updateUser(gender: String?, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws {
      updateUserExpectation?.fulfill()
    }
    
    func loadCurrentUser() async -> User? {
      return User(email: "email", username: "username")
    }
    
    var createUserExpectation: XCTestExpectation?
    func createUser(person: User) async {
      createUserExpectation?.fulfill()
    }
  }
  
  class MockAuthService: AuthServiceProtocol {
    var dataStore: UserDataStoreProtocol
    
    init(dataStore: UserDataStoreProtocol) {
      self.dataStore = dataStore
    }
    var expectation: XCTestExpectation?
    var expectedResult: String?
    var shouldFail: Bool = false
    
    func register(email: String, password: String, username: String, fullName: String) async throws {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
    }
    
    func login(email: String, password: String) async throws {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
    }
  }
}

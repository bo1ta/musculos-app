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
    
    let mockModule = MockAuthModule()
    mockModule.expectation = shouldSignInExpectation
    
    let viewModel = AuthViewModel(module: mockModule, dataStore: nil)
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
    
    let mockModule = MockAuthModule()
    mockModule.expectation = shouldSignInExpectation
    mockModule.shouldFail = true
    
    let viewModel = AuthViewModel(module: mockModule, dataStore: nil)
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
    
    let mockModule = MockAuthModule()
    mockModule.expectation = shouldSignUpExpectation
    
    let viewModel = AuthViewModel(module: mockModule, dataStore: nil)
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
    
    let mockModule = MockAuthModule()
    mockModule.expectation = shouldSignUpExpectation
    mockModule.shouldFail = true
    
    let viewModel = AuthViewModel(module: mockModule, dataStore: nil)
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
  class MockAuthModule: Authenticatable {
    var expectation: XCTestExpectation?
    var expectedResult: String?
    var shouldFail: Bool = false
    
    func register(email: String, password: String, username: String, fullName: String) async throws -> String {      
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResult ?? "some-token"
    }
    
    func login(email: String, password: String) async throws -> String {
      expectation?.fulfill()
      
      if shouldFail {
        throw MusculosError.badRequest
      }
      
      return expectedResult ?? "some-token"
    }
  }
}

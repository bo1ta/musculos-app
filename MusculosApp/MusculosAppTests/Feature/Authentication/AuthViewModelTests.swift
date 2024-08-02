//
//  AuthViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 28.03.2024.
//

import XCTest
import Factory
import Storage
import Utility
import Models
@testable import MusculosApp

final class AuthViewModelTests: XCTestCase, MusculosTestBase {
  override func tearDown() {
    Container.shared.reset()
    super.tearDown()
  }

  @MainActor
  func testInitialValues() {
    let viewModel = AuthViewModel(initialStep: .login)
    XCTAssertEqual(viewModel.step, .login)
    XCTAssertEqual(viewModel.email, "")
    XCTAssertEqual(viewModel.password, "")
    XCTAssertEqual(viewModel.confirmPassword, "")
    XCTAssertEqual(viewModel.username, "")
  }

  @MainActor
  func testSignIn() async throws {
    let shouldSignInExpectation = self.expectation(description: "should sign in")
    
    var mockService = MockAuthService()
    mockService.expectation = shouldSignInExpectation

    Container.shared.authService.register { mockService }

    let viewModel = AuthViewModel(initialStep: .login)

    let eventExpectation = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .onLoginSuccess = event {
        return true
      }
      return false
    })

    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.signIn()

    await fulfillment(of: [shouldSignInExpectation, eventExpectation], timeout: 1)
  }
  
  @MainActor
  func testSignInFails() async throws {
    let shouldSignInExpectation = self.expectation(description: "should try to sign in")
    
    var mockService = MockAuthService()
    mockService.expectation = shouldSignInExpectation
    mockService.shouldFail = true

    Container.shared.authService.register { mockService }

    let viewModel = AuthViewModel(initialStep: .login)

    let eventExpectation = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .onLoginFailure = event {
        return true
      }
      return false
    })

    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.signIn()

    await fulfillment(of: [shouldSignInExpectation, eventExpectation], timeout: 1)
  }
  
  @MainActor
  func testSignUp() async throws {
    let shouldSignUpExpectation = self.expectation(description: "should sign up")
    
    var mockService = MockAuthService()
    mockService.expectation = shouldSignUpExpectation

    Container.shared.authService.register { mockService }

    let viewModel = AuthViewModel(initialStep: .register)
    XCTAssertEqual(viewModel.step, .register)

    let eventExpectation = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .onRegisterSuccess = event {
        return true
      }
      return false
    })

    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.username = "john.doe"
    viewModel.signUp()

    await fulfillment(of: [shouldSignUpExpectation, eventExpectation], timeout: 1)
  }
  
  @MainActor
  func testSignUpFails() async throws {
    let shouldSignUpExpectation = self.expectation(description: "should try to sign up")
    
    var mockService = MockAuthService()
    mockService.expectation = shouldSignUpExpectation
    mockService.shouldFail = true

    Container.shared.authService.register { mockService }

    let viewModel = AuthViewModel(initialStep: .register)
    XCTAssertEqual(viewModel.step, .register)

    let eventExpectation = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .onRegisterFailure = event {
        return true
      }
      return false
    })

    viewModel.email = "some-email@email.com"
    viewModel.password = "some-password"
    viewModel.confirmPassword = "some-password"
    viewModel.username = "john.doe"
    viewModel.signUp()

    await fulfillment(of: [shouldSignUpExpectation, eventExpectation], timeout: 1)
  }
}

/// MARK: - Mocks
///
extension AuthViewModelTests {
  struct MockDataStore: UserDataStoreProtocol {
    var updateUserExpectation: XCTestExpectation?

    func updateProfile(userId: UUID, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws {
      updateUserExpectation?.fulfill()
    }
    
    func loadProfile(userId: UUID) async -> UserProfile? {
      return UserProfile(userId: UUID(), email: "email", username: "username")
    }
    
    func loadProfileByEmail(_ email: String) async -> UserProfile? {
      return UserProfile(userId: UUID(), email: "email", username: "username")
    }
    

    func updateUser(gender: String?, weight: Int?, height: Int?, primaryGoalId: Int?, level: String?, isOnboarded: Bool) async throws {
    }

    func createUser(profile: UserProfile) async throws {

    }

  }
  
  struct MockAuthService: AuthServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedResult: String?
    var shouldFail: Bool = false

    func register(email: String, password: String, username: String) async throws -> UserSession {
      expectation?.fulfill()

      if shouldFail {
        throw MusculosError.badRequest
      }

      return UserSession(authToken: "authtoken", userId: UUID(), email: "email@email.com", isOnboarded: true)
    }
    
    func login(email: String, password: String) async throws -> UserSession {
      expectation?.fulfill()

      if shouldFail {
        throw MusculosError.badRequest
      }

      return UserSession(authToken: "authtoken", userId: UUID(), email: "email@email.com", isOnboarded: true)
    }
  }
}

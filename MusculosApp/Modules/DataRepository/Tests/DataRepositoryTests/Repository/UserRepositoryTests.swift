//
//  UserRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Factory
import Foundation
import Network
import Testing
import XCTest

@testable import DataRepository
@testable import Models
@testable import NetworkClient
@testable import Storage
@testable import Utility

// MARK: - UserRepositoryTests

class UserRepositoryTests: XCTestCase {
  func testRegister() async throws {
    let expectation = self.expectation(description: "should call register")
    let expectedUserSession = mockUserSession
    let mockUserService = MockUserService(expectation: expectation, expectedUserSession: expectedUserSession)
    NetworkContainer.shared.userService.register { mockUserService }
    defer { NetworkContainer.shared.userService.reset() }

    let userSession = try await UserRepository().register(email: "test@test.com", password: "password", username: "username")

    XCTAssertEqual(userSession.token.value, expectedUserSession.token.value)
    await fulfillment(of: [expectation], timeout: 1)
  }

  func testLogin() async throws {
    let expectation = self.expectation(description: "should call login")
    let expectedUserSession = mockUserSession
    let mockUserService = MockUserService(expectation: expectation, expectedUserSession: expectedUserSession)
    NetworkContainer.shared.userService.register { mockUserService }
    defer { NetworkContainer.shared.userService.reset() }

    let userSession = try await UserRepository().login(email: "test@test.com", password: "password")

    XCTAssertEqual(userSession.token.value, expectedUserSession.token.value)
    await fulfillment(of: [expectation], timeout: 1)
  }

  func testGetCurrentUser() async throws {
    let expectedProfile = UserProfileFactory.createUser()
    let expectation = self.expectation(description: "should call service")
    let mockUserService = MockUserService(expectation: expectation)
    NetworkContainer.shared.userService.register { mockUserService }
    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: expectedProfile.id))
    }
    defer {
      NetworkContainer.shared.userService.reset()
      NetworkContainer.shared.userManager.reset()
    }

    let userProfile = try #require(try await UserRepository().getCurrentUser())
    #expect(userProfile == expectedProfile)
    await fulfillment(of: [expectation], timeout: 0.1)
  }

  func testUpdateOnboardingData() async throws {
    let currentUser = UserProfileFactory.createUser()
    let expectation = self.expectation(description: "should call service")
    let mockUserService = MockUserService(expectation: expectation, expectedProfile: currentUser)
    NetworkContainer.shared.userService.register { mockUserService }
    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: currentUser.id))
    }
    defer {
      NetworkContainer.shared.userService.reset()
      NetworkContainer.shared.userManager.reset()
    }

    let repository = UserRepository()
    let onboardingData = OnboardingData(weight: 10, height: 10, level: OnboardingConstants.Level.advanced.description, goal: nil)
    try await repository.updateProfileUsingOnboardingData(onboardingData)

    let currentProfile = try await repository.getCurrentUser()
    XCTAssertEqual(Int(currentProfile?.weight ?? 0), onboardingData.weight)
    XCTAssertEqual(Int(currentProfile?.height ?? 0), onboardingData.height)
    XCTAssertEqual(currentProfile?.level, onboardingData.level)
    await fulfillment(of: [expectation], timeout: 1)
  }
}

extension UserRepositoryTests {
  private var mockUserSession: UserSession {
    UserSession(token: .init(value: "token"), user: .init(id: UUID()))
  }

  private struct MockUserService: UserServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedUserSession: UserSession?
    var expectedProfile: UserProfile?

    init(expectation: XCTestExpectation? = nil, expectedUserSession: UserSession? = nil, expectedProfile: UserProfile? = nil) {
      self.expectation = expectation
      self.expectedUserSession = expectedUserSession
      self.expectedProfile = expectedProfile
    }

    func register(email _: String, password _: String, username _: String) async throws -> UserSession {
      expectation?.fulfill()

      if let expectedUserSession {
        return expectedUserSession
      }
      throw MusculosError.unexpectedNil
    }

    func login(email _: String, password _: String) async throws -> UserSession {
      expectation?.fulfill()

      if let expectedUserSession {
        return expectedUserSession
      }
      throw MusculosError.unexpectedNil
    }

    func currentUser() async throws -> UserProfile {
      expectation?.fulfill()

      if let expectedProfile {
        return expectedProfile
      }
      throw MusculosError.unexpectedNil
    }

    func updateUser(
      weight _: Int?,
      height _: Int?,
      primaryGoalID _: UUID?,
      level _: String?,
      isOnboarded _: Bool)
      async throws -> UserProfile
    {
      expectation?.fulfill()
      if let expectedProfile {
        return expectedProfile
      }
      throw MusculosError.unexpectedNil
    }
  }
}

//
//  UserStoreTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Testing
import Factory
import Combine
import Foundation
import XCTest
import Network

@testable import DataRepository
@testable import Storage
@testable import NetworkClient
@testable import Models
@testable import Utility

class UserStoreTests: XCTestCase {
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

  func testAuthenticateSession() async throws {
    let userFactory = UserProfileFactory()
    userFactory.isPersistent = false
    let expectedUser = userFactory.create()

    let expectedSession = UserSession(
      token: .init(value: "super-secret-token"),
      user: .init(id: expectedUser.userId))

    let updateSessionExpectation = self.expectation(description: "should call update session")
    let mockUserSessionManager = MockUserSessionManager(updateExpectation: updateSessionExpectation)
    StorageContainer.shared.userManager.register { mockUserSessionManager }
    defer { StorageContainer.shared.userManager.reset() }

    let repositoryExpectation = self.expectation(description: "should call add exercise")
    let mockRepository = MockUserRepository(
      expectation: repositoryExpectation,
      expectedUserProfile: expectedUser)
    DataRepositoryContainer.shared.userRepository.register { mockRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }


    let userStore = UserStore()

    let eventExpectation = self.expectation(description: "should publish didLogin event")
    let cancellable = userStore.eventPublisher.sink { event in
      XCTAssertEqual(event, .didLogin)
      eventExpectation.fulfill()
    }
    defer { cancellable.cancel() }

    await userStore.authenticateSession(expectedSession)
    await fulfillment(of: [updateSessionExpectation, repositoryExpectation, eventExpectation])
  }

  func testLoadCurrentUser() async throws {
    let expectedUser = UserProfileFactory.createUser()
    let repositoryExpectation = self.expectation(description: "should call add exercise")
    let mockRepository = MockUserRepository(
      expectation: repositoryExpectation,
      expectedUserProfile: expectedUser)
    DataRepositoryContainer.shared.userRepository.register { mockRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }

    let userStore = UserStore()
    let userProfile = await userStore.loadCurrentUser()
    XCTAssertEqual(userProfile, expectedUser)
    await fulfillment(of: [repositoryExpectation])
  }

  func testUpdateOnboardingStatus() async throws {
    let repositoryExpectation = self.expectation(description: "should call add exercise")
    let mockRepository = MockUserRepository(expectation: repositoryExpectation)
    DataRepositoryContainer.shared.userRepository.register { mockRepository }
    defer { DataRepositoryContainer.shared.userRepository.reset() }

    let userStore = UserStore()

    let eventExpectation = self.expectation(description: "should publish didFinishOnboarding event")
    let cancellable = userStore.eventPublisher.sink { event in
      XCTAssertEqual(event, .didFinishOnboarding)
      eventExpectation.fulfill()
    }
    defer { cancellable.cancel() }

    await userStore.updateOnboardingStatus(OnboardingData(weight: 20, height: 20, level: "level", goal: nil))
    await fulfillment(of: [repositoryExpectation, eventExpectation])
  }
}

extension UserStoreTests {
  private struct MockUserSessionManager: UserSessionManagerProtocol {
    var updateExpectation: XCTestExpectation?
    var clearExpectation: XCTestExpectation?
    var expectedUserSessionState: UserSessionState?
    var expectedSession: UserSession?

    init(updateExpectation: XCTestExpectation? = nil, clearExpectation: XCTestExpectation? = nil, expectedUserSessionState: UserSessionState? = nil, expectedSession: UserSession? = nil) {
      self.updateExpectation = updateExpectation
      self.clearExpectation = clearExpectation
      self.expectedUserSessionState = expectedUserSessionState
      self.expectedSession = expectedSession
    }

    func getCurrentState() -> UserSessionState {
      return expectedUserSessionState ?? .unauthenticated
    }

    func updateSession(_ session: UserSession) {
      updateExpectation?.fulfill()
      guard let expectedSession else {
        return
      }
      XCTAssertEqual(expectedSession.token.value, session.token.value)
    }

    func clearSession() {
      clearExpectation?.fulfill()
    }
  }

  private actor MockUserRepository: UserRepositoryProtocol {
    var expectation: XCTestExpectation?
    var expectedUserSession: UserSession?
    var expectedUserProfile: UserProfile?

    init(expectation: XCTestExpectation? = nil, expectedUserSession: UserSession? = nil, expectedUserProfile: UserProfile? = nil) {
      self.expectation = expectation
      self.expectedUserSession = expectedUserSession
      self.expectedUserProfile = expectedUserProfile
    }

    func register(email: String, password: String, username: String) async throws -> UserSession {
      expectation?.fulfill()

      guard let expectedUserSession else {
        throw MusculosError.unexpectedNil
      }
      return expectedUserSession
    }

    func login(email: String, password: String) async throws -> UserSession {
      expectation?.fulfill()

      guard let expectedUserSession else {
        throw MusculosError.unexpectedNil
      }
      return expectedUserSession
    }

    func getCurrentUser() async throws -> UserProfile? {
      expectation?.fulfill()

      guard let expectedUserProfile else {
        throw MusculosError.unexpectedNil
      }
      return expectedUserProfile
    }

    func updateProfileUsingOnboardingData(_ onboardingData: OnboardingData) async throws {
      expectation?.fulfill()
    }
  }
}

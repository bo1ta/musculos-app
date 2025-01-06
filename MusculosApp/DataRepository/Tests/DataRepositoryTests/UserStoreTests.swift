//
//  UserStoreTests.swift
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

// MARK: - UserStoreTests

class UserStoreTests: XCTestCase {
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

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
    await fulfillment(of: [repositoryExpectation], timeout: 1)
  }

  func testUpdateOnboardingStatus() async throws {
    let userProfile = UserProfileFactory.createUser()

    let repositoryExpectation = self.expectation(description: "should call methods")
    repositoryExpectation.expectedFulfillmentCount = 2
    let mockRepository = MockUserRepository(
      expectation: repositoryExpectation,
      expectedUserSession: UserSession.mockWithUserID(userProfile.userId),
      expectedUserProfile: userProfile)
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
    await fulfillment(of: [repositoryExpectation, eventExpectation], timeout: 1)
  }
}

extension UserStoreTests {
  private struct MockUserSessionManager: UserSessionManagerProtocol {
    var updateExpectation: XCTestExpectation?
    var clearExpectation: XCTestExpectation?
    var expectedUserSessionState: UserSessionState?
    var expectedSession: UserSession?

    init(
      updateExpectation: XCTestExpectation? = nil,
      clearExpectation: XCTestExpectation? = nil,
      expectedUserSessionState: UserSessionState? = nil,
      expectedSession: UserSession? = nil)
    {
      self.updateExpectation = updateExpectation
      self.clearExpectation = clearExpectation
      self.expectedUserSessionState = expectedUserSessionState
      self.expectedSession = expectedSession
    }

    func getCurrentState() -> UserSessionState {
      expectedUserSessionState ?? .unauthenticated
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

    init(
      expectation: XCTestExpectation? = nil,
      expectedUserSession: UserSession? = nil,
      expectedUserProfile: UserProfile? = nil)
    {
      self.expectation = expectation
      self.expectedUserSession = expectedUserSession
      self.expectedUserProfile = expectedUserProfile
    }

    func register(email _: String, password _: String, username _: String) async throws -> UserSession {
      expectation?.fulfill()

      guard let expectedUserSession else {
        throw MusculosError.unexpectedNil
      }
      return expectedUserSession
    }

    func login(email _: String, password _: String) async throws -> UserSession {
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

    func updateProfileUsingOnboardingData(_: OnboardingData) async throws {
      expectation?.fulfill()
    }
  }
}

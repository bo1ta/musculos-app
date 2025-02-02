//
//  ExerciseSessionRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Factory
import Foundation
import Testing
import XCTest

@testable import DataRepository
@testable import Models
@testable import NetworkClient
@testable import Storage
@testable import Utility

// MARK: - ExerciseSessionRepositoryTests

class ExerciseSessionRepositoryTests: XCTestCase {
  @Injected(\StorageContainer.exerciseSessionDataStore) private var dataStore
  @Injected(\StorageContainer.userDataStore) private var userDataStore

  override class func tearDown() {
    NetworkContainer.shared.userManager.reset()
    super.tearDown()
  }

  func testGetExerciseSessionMakesNetworkRequestAndSyncsCoreData() async throws {
    setupCurrentUser()

    let expectedResult = [ExerciseSessionFactory.createExerciseSession()]
    let expectation = self.expectation(description: "should get onboarding goals")
    let mockService = MockExerciseSessionService(expectation: expectation, expectedExerciseSessions: expectedResult)

    NetworkContainer.shared.exerciseSessionService.register { mockService }
    defer { NetworkContainer.shared.exerciseSessionService.reset() }

    let results = try await ExerciseSessionRepository().getExerciseSessions()
    XCTAssertFalse(results.isEmpty)
    await fulfillment(of: [expectation], timeout: 1)

    let firstResult = try #require(results.first)
    // data store is synced
    let localExerciseSession = await dataStore.exerciseSessionByID(firstResult.id)
    XCTAssertEqual(firstResult.exercise, localExerciseSession?.exercise)
  }

  func testGetRecommendationsForLeastWorkedMuscles() async throws {
    setupCurrentUser()

    let _ = ExerciseFactory.make { factory in
      factory.primaryMuscles = [MuscleType.chest.rawValue]
    }

    let completedExercise = ExerciseFactory.make { factory in
      factory.primaryMuscles = [MuscleType.triceps.rawValue]
    }

    let _ = ExerciseSessionFactory.make { factory in
      factory.exercise = completedExercise
    }

    // shouldn't return any "triceps" exercise
    let results = try await ExerciseRepository().getRecommendationsForLeastWorkedMuscles()
    let count = results.filter { $0.primaryMuscles.contains(MuscleType.triceps.rawValue) }.count
    XCTAssertEqual(count, 0)
  }

  func testAddSessionCallsServiceAndSyncsWithStorage() async throws {
    let user = UserProfileFactory.createUser()
    NetworkContainer.shared.userManager.register { StubUserSessionManager(expectedUser: .init(id: user.id)) }
    defer { NetworkContainer.shared.userManager.reset() }

    let userExperience = UserExperienceFactory.createUserExperience()
    let userExperienceEntry = UserExperienceEntry(
      id: UUID(),
      userExperience: userExperience,
      xpGained: 100)
    let exerciseSession = ExerciseSession(user: user, exercise: ExerciseFactory.createExercise())

    let expectation = self.expectation(description: "should call service")
    let mockService = MockExerciseSessionService(expectation: expectation, expectedUserExperienceEntry: userExperienceEntry)
    NetworkContainer.shared.exerciseSessionService.register { mockService }
    defer { NetworkContainer.shared.exerciseSessionService.reset() }

    let repository = ExerciseSessionRepository()
    let result = try await repository.addSession(exerciseSession)
    await repository.syncManager.waitForAllBackgroundTasks()

    let localResult = await userDataStore.userExperienceEntryByID(userExperienceEntry.id)
    XCTAssertEqual(result.xpGained, localResult?.xpGained)
    await fulfillment(of: [expectation], timeout: 1)
  }

  private func setupCurrentUser() {
    let user = UserProfileFactory.createUser()

    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: user.id))
    }
  }
}

// MARK: ExerciseSessionRepositoryTests.MockExerciseSessionService

extension ExerciseSessionRepositoryTests {
  private struct MockExerciseSessionService: ExerciseSessionServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedUserExperienceEntry: UserExperienceEntry?
    var expectedExerciseSessions: [ExerciseSession]

    init(
      expectation: XCTestExpectation? = nil,
      expectedExerciseSessions: [ExerciseSession] = [],
      expectedUserExperienceEntry: UserExperienceEntry? = nil)
    {
      self.expectation = expectation
      self.expectedExerciseSessions = expectedExerciseSessions
      self.expectedUserExperienceEntry = expectedUserExperienceEntry
    }

    func getAll() async throws -> [ExerciseSession] {
      expectation?.fulfill()
      return expectedExerciseSessions
    }

    func add(_: ExerciseSession) async throws -> UserExperienceEntry {
      expectation?.fulfill()

      if let expectedUserExperienceEntry {
        return expectedUserExperienceEntry
      }
      throw MusculosError.unexpectedNil
    }
  }
}

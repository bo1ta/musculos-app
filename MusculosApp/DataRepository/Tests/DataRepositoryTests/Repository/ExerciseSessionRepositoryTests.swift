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
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

  override class func tearDown() {
    StorageContainer.shared.userManager.reset()
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
    await fulfillment(of: [expectation])

    let firstResult = try #require(results.first)
    // data store is synced
    let localExerciseSession = await coreDataStore.exerciseSessionByID(firstResult.sessionId)
    XCTAssertEqual(firstResult.exercise, localExerciseSession?.exercise)
  }

  func testGetRecommendationsForLeastWorkedMuscles() async throws {
    setupCurrentUser()

    let exerciseFactory = ExerciseFactory()
    exerciseFactory.primaryMuscles = [MuscleType.chest.rawValue]
    let chestExercise = exerciseFactory.create()

    exerciseFactory.primaryMuscles = [MuscleType.triceps.rawValue]
    let completedExercise = exerciseFactory.create()

    let exerciseSessionFactory = ExerciseSessionFactory()
    exerciseSessionFactory.exercise = completedExercise
    _ = exerciseSessionFactory.create()

    // shouldn't return any "triceps" exercise
    let results = try await ExerciseSessionRepository().getRecommendationsForLeastWorkedMuscles()
    let count = results.filter { $0.primaryMuscles.contains(MuscleType.triceps.rawValue) }.count
    XCTAssertEqual(count, 0)
  }

  func testAddSessionCallsServiceAndSyncsWithStorage() async throws {
    let user = UserProfileFactory.createUser()
    StorageContainer.shared.userManager.register { StubUserSessionManager(expectedUser: .init(id: user.userId)) }
    defer { StorageContainer.shared.userManager.reset() }

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
    await repository.backgroundWorker.waitForAll()

    let localResult = await coreDataStore.userExperienceEntryByID(userExperienceEntry.id)
    XCTAssertEqual(result.xpGained, localResult?.xpGained)
    await fulfillment(of: [expectation])
  }

  private func setupCurrentUser() {
    let user = UserProfileFactory.createUser()

    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: user.userId))
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

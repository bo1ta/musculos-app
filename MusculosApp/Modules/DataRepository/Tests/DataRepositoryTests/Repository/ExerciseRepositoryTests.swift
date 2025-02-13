//
//  ExerciseRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 01.01.2025.
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

// MARK: - ExerciseRepositoryTests

class ExerciseRepositoryTests: XCTestCase {
  @Injected(\StorageContainer.exerciseDataStore) private var dataStore

  func testAddExercisePopulatesDataStoreAndCallsService() async throws {
    let serviceExpectation = self.expectation(description: "should call add exercise")
    var stubService = ExerciseServiceStub()
    stubService.expectation = serviceExpectation
    NetworkContainer.shared.exerciseService.register {
      ExerciseServiceStub(expectation: serviceExpectation)
    }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let exercise = ExerciseFactory.createExercise(isPersistent: false)
    let repository = ExerciseRepository()
    try await repository.addExercise(exercise)
    await repository.backgroundWorker.waitForAll()

    let localExercise = try #require(await dataStore.exerciseByID(exercise.id))
    XCTAssertEqual(localExercise, exercise)
    await fulfillment(of: [serviceExpectation], timeout: 1)
  }

  func testAddExerciseCompletesWhenServiceThrows() async throws {
    let serviceExpectation = self.expectation(description: "should call add exercise")
    var stubService = ExerciseServiceStub()
    stubService.expectation = serviceExpectation
    stubService.shouldFail = true
    NetworkContainer.shared.exerciseService.register { [stubService] in stubService }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let exercise = ExerciseFactory.createExercise(isPersistent: false)
    let repository = ExerciseRepository()
    try await repository.addExercise(exercise)
    await repository.backgroundWorker.waitForAll()

    let localExercise = try #require(await dataStore.exerciseByID(exercise.id))
    XCTAssertEqual(localExercise, exercise)
    await fulfillment(of: [serviceExpectation], timeout: 1)
  }

  func testGetExercisesPopulatesDataStore() async throws {
    StorageContainer.shared.storageManager().reset()

    let exercise = ExerciseFactory.createExercise(isPersistent: false)

    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectedResult: [exercise]) }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let repository = ExerciseRepository()
    let results = try await repository.getExercises()
    await repository.backgroundWorker.waitForAll()

    let firstResult = try #require(results.first)
    XCTAssertEqual(firstResult.id, exercise.id)

    let localExercise = await dataStore.exerciseByID(exercise.id)
    XCTAssertEqual(localExercise?.name, exercise.name)
  }

  func testGetExercisesUsesLocalStoreIfNotConntectedToInternet() async throws {
    let serviceExpectation = self.expectation(description: "should NOT call the service")
    serviceExpectation.isInverted = true

    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectation: serviceExpectation) }
    NetworkContainer.shared.networkMonitor.register { StubNetworkMonitor(isConnected: false) }
    defer {
      NetworkContainer.shared.exerciseService.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    // populate data store
    _ = ExerciseFactory.createExercise()

    let repository = ExerciseRepository()
    let exercises = try await repository.getExercises()

    XCTAssertFalse(exercises.isEmpty)
    await fulfillment(of: [serviceExpectation], timeout: 0.1)
  }

  func testGetExerciseDetailsUsesLocalExerciseIfExists() async throws {
    let serviceExpectation = self.expectation(description: "should NOT call the service")
    serviceExpectation.isInverted = true

    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectation: serviceExpectation) }
    NetworkContainer.shared.networkMonitor.register { StubNetworkMonitor(isConnected: false) }
    defer {
      NetworkContainer.shared.exerciseService.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    let exercise = ExerciseFactory.createExercise()

    let repository = ExerciseRepository()
    let localExercise = try await repository.getExerciseDetails(for: exercise.id)

    XCTAssertEqual(localExercise, exercise)
    await fulfillment(of: [serviceExpectation], timeout: 0.1)
  }

  func testGetExerciseDetailsUsesServiceIfLocalExerciseDoesNotExist() async throws {
    let serviceExpectation = self.expectation(description: "should call the service")
    let expectedExercise = ExerciseFactory.createExercise(isPersistent: false)

    NetworkContainer.shared.exerciseService.register {
      ExerciseServiceStub(
        expectation: serviceExpectation,
        expectedResult: [expectedExercise])
    }
    NetworkContainer.shared.networkMonitor.register { StubNetworkMonitor(isConnected: true) }
    defer {
      NetworkContainer.shared.exerciseService.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    let repository = ExerciseRepository()
    let remoteExercise = try await repository.getExerciseDetails(for: expectedExercise.id)

    XCTAssertEqual(remoteExercise, expectedExercise)
    await fulfillment(of: [serviceExpectation], timeout: 1)
  }

  func testGetRecommendedExercisesByMuscleGroupsForUserSessions() async throws {
    let user = UserProfileFactory.createUser()

    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.id))
    }
    defer {
      NetworkContainer.shared.userManager.reset()
    }

    // Populate data store with an exercise with the primary muscles unrelated to the user past session
    let exerciseFactory = ExerciseFactory()
    exerciseFactory.primaryMuscles = [MuscleType.abdominals.rawValue]
    _ = exerciseFactory.create()

    exerciseFactory.primaryMuscles = [MuscleType.chest.rawValue]

    let exerciseSessionFactory = ExerciseSessionFactory()
    exerciseSessionFactory.exercise = exerciseFactory.create()
    exerciseSessionFactory.user = user
    _ = exerciseSessionFactory.create()

    let repository = ExerciseRepository()
    let exercises = try await repository.getRecommendedExercisesByMuscleGroups()
    XCTAssertFalse(exercises.isEmpty)
  }

  func testGetRecommendedExercisesByMuscleGroupsEmpty() async throws {
    let user = UserProfileFactory.createUser()

    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.id))
    }
    defer {
      NetworkContainer.shared.userManager.reset()
    }

    _ = ExerciseFactory.createExercise()

    let repository = ExerciseRepository()
    let exercises = try await repository.getRecommendedExercisesByMuscleGroups()
    XCTAssertTrue(exercises.isEmpty)
  }

  func testGetRecommendedExercisesByGoals() async throws {
    let user = UserProfileFactory.createUser()

    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.id))
    }
    defer {
      NetworkContainer.shared.userManager.reset()
    }

    let _ = ExerciseFactory.make { factory in
      factory.category = ExerciseConstants.CategoryType.cardio.rawValue
    }

    let _ = GoalFactory.make { factory in
      factory.category = Goal.Category.loseWeight.rawValue
      factory.user = user
    }

    let exercises = await ExerciseRepository().getRecommendedExercisesByGoals()
    XCTAssertFalse(exercises.isEmpty)
  }

  func testSearchByQueryUsesLocalStorageFirst() async throws {
    let exerciseFactory = ExerciseFactory()
    exerciseFactory.name = "Test one"
    _ = exerciseFactory.create()

    let serviceExpectation = self.expectation(description: "should NOT call service")
    serviceExpectation.isInverted = true
    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectation: serviceExpectation) }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let exercises = try await ExerciseRepository().searchByQuery("Test")
    XCTAssertFalse(exercises.isEmpty)
    await fulfillment(of: [serviceExpectation], timeout: 0.1)
  }

  func testSearchByQueryUsesRemoteAsFallback() async throws {
    let serviceExpectation = self.expectation(description: "should call service")
    let expectedResult = [ExerciseFactory.createExercise(isPersistent: false)]
    NetworkContainer.shared.exerciseService.register {
      ExerciseServiceStub(
        expectation: serviceExpectation,
        expectedResult: expectedResult)
    }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let exercises = try await ExerciseRepository().searchByQuery("Peanut")
    XCTAssertFalse(exercises.isEmpty)
    await fulfillment(of: [serviceExpectation], timeout: 1)
  }
}

// MARK: ExerciseRepositoryTests.ExerciseServiceStub

extension ExerciseRepositoryTests {
  struct ExerciseServiceStub: ExerciseServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedResult: [Exercise]
    var shouldFail: Bool

    init(expectation: XCTestExpectation? = nil, expectedResult: [Exercise] = [], shouldFail: Bool = false) {
      self.expectation = expectation
      self.expectedResult = expectedResult
      self.shouldFail = shouldFail
    }

    private func getOrThrow() throws -> [Exercise] {
      if shouldFail {
        throw MusculosError.unknownError
      }
      return expectedResult
    }

    func getExercises() async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func searchByQuery(_: String) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getByMuscle(_: Models.MuscleType) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getByMuscleGroup(_: Models.MuscleGroup) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getExerciseDetails(for _: UUID) async throws -> Exercise {
      expectation?.fulfill()

      if let firstExercise = try getOrThrow().first {
        return firstExercise
      }
      throw MusculosError.unexpectedNil
    }

    func getFavoriteExercises() async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func setFavoriteExercise(_: Models.Exercise, isFavorite _: Bool) async throws {
      _ = try getOrThrow()
      expectation?.fulfill()
    }

    func getByWorkoutGoal(_: WorkoutGoal) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func addExercise(_: Exercise) async throws {
      expectation?.fulfill()
      _ = try getOrThrow()
    }
  }
}

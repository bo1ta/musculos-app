//
//  ExerciseRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 01.01.2025.
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

class ExerciseRepositoryTests: XCTestCase {
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

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

    let localExercise = try #require(await coreDataStore.exerciseByID(exercise.id))
    XCTAssertEqual(localExercise, exercise)
    await fulfillment(of: [serviceExpectation])
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

    let localExercise = try #require(await coreDataStore.exerciseByID(exercise.id))
    XCTAssertEqual(localExercise, exercise)
    await fulfillment(of: [serviceExpectation])
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

    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectation: serviceExpectation, expectedResult: [expectedExercise]) }
    NetworkContainer.shared.networkMonitor.register { StubNetworkMonitor(isConnected: true) }
    defer {
      NetworkContainer.shared.exerciseService.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    let repository = ExerciseRepository()
    let remoteExercise = try await repository.getExerciseDetails(for: expectedExercise.id)

    XCTAssertEqual(remoteExercise, expectedExercise)
    await fulfillment(of: [serviceExpectation])
  }

  func testGetRecommendedExercisesByMuscleGroupsForUserSessions() async throws {
    let user = UserProfileFactory.createUser()

    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.userId))
    }
    defer {
      StorageContainer.shared.userManager.reset()
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

    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.userId))
    }
    defer {
      StorageContainer.shared.userManager.reset()
    }

    _ = ExerciseFactory.createExercise()

    let repository = ExerciseRepository()
    let exercises = try await repository.getRecommendedExercisesByMuscleGroups()
    XCTAssertTrue(exercises.isEmpty)
  }

  func testGetRecommendedExercisesByGoals() async throws {
    let user = UserProfileFactory.createUser()

    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: UserSession.User(id: user.userId))
    }
    defer {
      StorageContainer.shared.userManager.reset()
    }

    let exerciseFactory = ExerciseFactory()
    exerciseFactory.category = ExerciseConstants.CategoryType.cardio.rawValue
    _ = exerciseFactory.create()

    let goalFactory = GoalFactory()
    goalFactory.category = Goal.Category.loseWeight.rawValue
    goalFactory.user = user
    _ = goalFactory.create()

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
    NetworkContainer.shared.exerciseService.register { ExerciseServiceStub(expectation: serviceExpectation, expectedResult: expectedResult) }
    defer { NetworkContainer.shared.exerciseService.reset() }

    let exercises = try await ExerciseRepository().searchByQuery("Peanut")
    XCTAssertFalse(exercises.isEmpty)
    await fulfillment(of: [serviceExpectation], timeout: 1)
  }
}

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

    func searchByQuery(_ query: String) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getByMuscle(_ muscle: Models.MuscleType) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getByMuscleGroup(_ muscleGroup: Models.MuscleGroup) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func getExerciseDetails(for exerciseID: UUID) async throws -> Exercise {
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

    func setFavoriteExercise(_ exercise: Models.Exercise, isFavorite: Bool) async throws {
      _ = try getOrThrow()
      expectation?.fulfill()
    }

    func getByWorkoutGoal(_ workoutGoal: WorkoutGoal) async throws -> [Exercise] {
      expectation?.fulfill()
      return try getOrThrow()
    }

    func addExercise(_ exercise: Exercise) async throws {
      expectation?.fulfill()
      _ = try getOrThrow()
    }
  }
}

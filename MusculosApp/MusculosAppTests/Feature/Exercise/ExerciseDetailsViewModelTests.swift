//
//  ExerciseDetailsViewModelTests.swift
//  MusculosAppTests
//
//  Created by Solomon Alexandru on 08.06.2024.
//

import Foundation
import XCTest
import Combine
import Factory
import Models
import Storage
import Utility

@testable import MusculosApp

class ExerciseDetailsViewModelTests: XCTestCase, MusculosTestBase {
  private var cancellables: Set<AnyCancellable> = []

  override func setUp() {
    super.setUp()

    Container.shared.exerciseSessionDataStore.register { MockExerciseSessionDataStore() }
    Container.shared.exerciseDataStore.register { StubExerciseDataStore() }
  }

  override func tearDown() {
    Container.shared.reset()
    super.tearDown()
  }

  @MainActor
  func testInitialValues() {
    let viewModel = ExerciseDetailsViewModel(exercise: ExerciseFactory.createExercise())
    XCTAssertEqual(viewModel.elapsedTime, 0)

    XCTAssertFalse(viewModel.isFavorite)
    XCTAssertFalse(viewModel.showChallengeExercise)
    XCTAssertFalse(viewModel.isTimerActive)

    XCTAssertNil(viewModel.timerTask)
    XCTAssertNil(viewModel.markFavoriteTask)
    XCTAssertNil(viewModel.saveExerciseSessionTask)
  }


  @MainActor
  func testInitialLoad() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: "Some Exercise")
    try await self.populateStorageWithExercise(exercise: exercise)

    let viewModel = ExerciseDetailsViewModel(exercise: exercise)
    await viewModel.initialLoad()

    XCTAssertFalse(viewModel.isFavorite)
  }

  @MainActor
  func testToggleIsFavorite() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: "Some Exercise")

    try await self.populateStorageWithExercise(exercise: exercise)

    let viewModel = ExerciseDetailsViewModel(exercise: exercise)
    XCTAssertNil(viewModel.markFavoriteTask)

    let eventPublisher = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .didUpdateFavorite = event {
        return true
      }
      return false
    })

    viewModel.isFavorite.toggle()

    XCTAssertTrue(viewModel.isFavorite)
    await fulfillment(of: [eventPublisher])
  }

  @MainActor
  func testToggleIsFavoriteFailure() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: "Some Exercise")

    let mockDataStore = StubExerciseDataStore()
    mockDataStore.shouldFail = true

    Container.shared.exerciseDataStore.register { mockDataStore }

    try await self.populateStorageWithExercise(exercise: exercise)

    let viewModel = ExerciseDetailsViewModel(exercise: exercise)
    XCTAssertNil(viewModel.markFavoriteTask)

    let eventPublisher = PublisherValueExpectation(viewModel.event, condition: { event in
      if case .didUpdateFavoriteFailure = event {
        return true
      }
      return false
    })

    viewModel.isFavorite.toggle()
    await fulfillment(of: [eventPublisher])

    XCTAssertFalse(viewModel.isFavorite)
  }
}

extension ExerciseDetailsViewModelTests {
  struct MockExerciseSessionDataStore: ExerciseSessionDataStoreProtocol {
    
    var addSessionExpectation: XCTestExpectation?
    var addSessionShouldFail: Bool = false
    func addSession(_ exercise: Exercise, date: Date) async throws {
      if addSessionShouldFail {
        throw MusculosError.badRequest
      }
      addSessionExpectation?.fulfill()
    }

    func addSession(_ exercise: Models.Exercise, date: Date, userId: UUID) async throws {}

    func getAll(for userId: UUID) async -> [ExerciseSession] {
      return []
    }

    func getCompletedToday(userId: UUID) async -> [ExerciseSession] {
      return []
    }

    func getCompletedSinceLastWeek(userId: UUID) async -> [ExerciseSession] {
      return []
    }

    func getCompletedSinceLastWeek() async -> [ExerciseSession] {
      return []
    }

    func getAll() async -> [ExerciseSession] {
      return []
    }

    func getCompletedToday() async -> [ExerciseSession] {
      return []
    }
  }
  
  struct MockGoalDataStore: GoalDataStoreProtocol {
    func incrementCurrentValue(_ goal: Goal) async throws {}
    
    func add(_ goal: Goal) async throws {}
    
    func getAll() async -> [Goal] {
      return []
    }
  }
}

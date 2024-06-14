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

@testable import MusculosApp

class ExerciseDetailsViewModelTests: XCTestCase, MusculosTestBase {
  private var cancellables: Set<AnyCancellable> = []
  
  override func setUp() {
    super.setUp()
    
    Container.shared.exerciseSessionDataStore.register { MockExerciseSessionDataStore() }
    Container.shared.exerciseDataStore.register { StubExerciseDataStore() }
  }
  
  override class func tearDown() {
    Container.shared.reset()
    super.tearDown()
  }
  
  func testInitialValues() {
    let viewModel = ExerciseDetailsViewModel(exercise: ExerciseFactory.createExercise())
    XCTAssertEqual(viewModel.elapsedTime, 0)
    
    XCTAssertFalse(viewModel.isFavorite)
    XCTAssertFalse(viewModel.showChallengeExercise)
    XCTAssertFalse(viewModel.isTimerActive)
    
    XCTAssertNil(viewModel.timer)
    XCTAssertNil(viewModel.markFavoriteTask)
    XCTAssertNil(viewModel.saveExerciseSessionTask)
  }
  
  
  func testInitialLoad() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: "Some Exercise")
    try await self.populateStorageWithExercise(exercise: exercise)

    let viewModel = ExerciseDetailsViewModel(exercise: exercise)
    await viewModel.initialLoad()
    
    XCTAssertFalse(viewModel.isFavorite)
  }
  
  func testToggleIsFavorite() async throws {
    let exercise = ExerciseFactory.createExercise(uuidString: UUID().uuidString, name: "Some Exercise")
    try await self.populateStorageWithExercise(exercise: exercise)
    
    let viewModel = ExerciseDetailsViewModel(exercise: exercise)
    XCTAssertNil(viewModel.markFavoriteTask)
    
    await viewModel.toggleIsFavorite()
    XCTAssertTrue(viewModel.isFavorite)
  }
}

extension ExerciseDetailsViewModelTests {
  struct MockExerciseSessionDataStore: ExerciseSessionDataStoreProtocol {
    func getCompletedSinceLastWeek() async -> [ExerciseSession] {
      return []
    }
    
    func getAll() async -> [ExerciseSession] {
      return []
    }
    
    func getCompletedToday() async -> [ExerciseSession] {
      return []
    }
    
    var addSessionExpectation: XCTestExpectation?
    var addSessionShouldFail: Bool = false
    func addSession(_ exercise: Exercise, date: Date) async throws {
      if addSessionShouldFail {
        throw MusculosError.badRequest
      }
      addSessionExpectation?.fulfill()
      
      return
    }
  }
  
  struct MockGoalDataStore: GoalDataStoreProtocol {
    func add(_ goal: Goal) async throws {
    }
    
    func getAll() async -> [Goal] {
      return []
    }
  }
}

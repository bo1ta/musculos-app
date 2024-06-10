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
    
    let markFavoriteTask = try XCTUnwrap(viewModel.markFavoriteTask)
    await markFavoriteTask.value
    
    XCTAssertTrue(viewModel.isFavorite)
  }
  
  func testDidSaveSubjectSuccess() async throws {
    let addSessionExpectation = self.expectation(description: "should call addSession")
    let didSaveExpectation = self.expectation(description: "should save expectation")
    
    let mockDataStore = MockExerciseSessionDataStore()
    mockDataStore.addSessionExpectation = addSessionExpectation
    
    Container.shared.exerciseSessionDataStore.register { mockDataStore }
    defer { Container.shared.reset() }
    
    let viewModel = ExerciseDetailsViewModel(exercise: ExerciseFactory.createExercise())
    var cancellable = Set<AnyCancellable>()
    viewModel.didSaveSubject.sink { didSave in
      if didSave {
        didSaveExpectation.fulfill()
      } else {
        XCTFail("Subject did not save!")
      }
    }
    .store(in: &cancellable)
    
    
    XCTAssertNil(viewModel.saveExerciseSessionTask)
    
    viewModel.saveExerciseSession()
  
    await self.fulfillment(of: [addSessionExpectation, didSaveExpectation])
  }
  
  func testDidSaveSubjectFailure() async throws {
    let addSessionExpectation = self.expectation(description: "should call addSession")
    let didNotSaveExpectation = self.expectation(description: "should not save expectation")
    
    let mockDataStore = MockExerciseSessionDataStore()
    mockDataStore.addSessionExpectation = addSessionExpectation
    
    Container.shared.exerciseSessionDataStore.register { mockDataStore }
    defer { Container.shared.reset() }
    
    let viewModel = ExerciseDetailsViewModel(exercise: ExerciseFactory.createExercise())
    var cancellable = Set<AnyCancellable>()
    viewModel.didSaveSubject.sink { didSave in
      if didSave {
        XCTFail("Should not save")
      } else {
        didNotSaveExpectation.fulfill()
      }
    }
    .store(in: &cancellable)
    
    
    XCTAssertNil(viewModel.saveExerciseSessionTask)
    
    viewModel.saveExerciseSession()
  
    await self.fulfillment(of: [addSessionExpectation, didNotSaveExpectation])
  }
}

extension ExerciseDetailsViewModelTests {
  class MockExerciseSessionDataStore: ExerciseSessionDataStoreProtocol {
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
    }
  }
}

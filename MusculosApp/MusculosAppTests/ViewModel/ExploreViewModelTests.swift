//
//  ExploreViewModelTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 02.01.2025.
//

import Combine
import Factory
import Fakery
import Foundation
import Models
import Testing
import XCTest

@testable import Components
@testable import DataRepository
@testable import MusculosApp
@testable import NetworkClient
@testable import Storage

// MARK: - ExploreViewModelTests

@MainActor
class ExploreViewModelTests: XCTestCase {
  func testInitialLoad() async throws {
    let user = UserProfileFactory.createUser()
    let goal = GoalFactory.make { factory in
      factory.userID = user.id
    }

    NetworkContainer.shared.userManager.register { StubUserSessionManager(expectedUserID: user.id) }

    let expectedExercises = [ExerciseFactory.createExercise()]
    let exerciseRepositoryStub = ExerciseRepositoryStub(expectedExercises: expectedExercises)
    DataRepositoryContainer.shared.exerciseRepository.register { exerciseRepositoryStub }

    let expectedExerciseSessions = [ExerciseSessionFactory.createExerciseSession()]
    let exerciseSessionRepositoryStub = ExerciseSessionRepositoryStub(expectedSessions: expectedExerciseSessions)
    DataRepositoryContainer.shared.exerciseSessionRepository.register { exerciseSessionRepositoryStub }

    defer {
      NetworkContainer.shared.userManager.reset()
      DataRepositoryContainer.shared.exerciseRepository.reset()
      DataRepositoryContainer.shared.exerciseSessionRepository.reset()
    }

    let viewModel = ExploreViewModel()
    await viewModel.initialLoad()

    XCTAssertEqual(viewModel.featuredExercises.resultsOrEmpty().count, 1)
    XCTAssertEqual(viewModel.recommendedExercisesByPastSessions.resultsOrEmpty().count, 1)
    XCTAssertEqual(viewModel.recommendedExercisesByGoals.resultsOrEmpty().count, 1)
  }

  func testSearchQuery() async throws {
    let expectedExercises = [ExerciseFactory.createExercise()]
    let exerciseRepositoryStub = ExerciseRepositoryStub(expectedExercises: expectedExercises)
    DataRepositoryContainer.shared.exerciseRepository.register { exerciseRepositoryStub }

    let currentUser = UserProfileFactory.createUser()
    NetworkContainer.shared.userManager.register { StubUserSessionManager(expectedUserID: currentUser.id) }

    defer {
      NetworkContainer.shared.userManager.reset()
      DataRepositoryContainer.shared.exerciseRepository.reset()
    }

    let viewModel = ExploreViewModel()
    viewModel.searchByMuscleQuery("query")

    let task = try XCTUnwrap(viewModel.searchQueryTask)
    await task.value

    XCTAssertEqual(viewModel.featuredExercises.resultsOrEmpty().count, 1)
  }
}

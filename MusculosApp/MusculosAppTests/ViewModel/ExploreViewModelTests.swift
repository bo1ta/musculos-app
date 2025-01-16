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
@testable import Storage

// MARK: - ExploreViewModelTests

@MainActor
class ExploreViewModelTests: XCTestCase {
  func testInitialLoad() async throws {
    let userFactory = UserProfileFactory()
    userFactory.goals = [GoalFactory.createGoal()]
    let currentUser = userFactory.create()

    let stubUserStore = UserStoreStub()
    stubUserStore.currentUser = currentUser
    Container.shared.userStore.register { stubUserStore }

    let expectedExercises = [ExerciseFactory.createExercise()]
    let exerciseRepositoryStub = ExerciseRepositoryStub(expectedExercises: expectedExercises)
    DataRepositoryContainer.shared.exerciseRepository.register { exerciseRepositoryStub }

    let expectedExerciseSessions = [ExerciseSessionFactory.createExerciseSession()]
    let exerciseSessionRepositoryStub = ExerciseSessionRepositoryStub(expectedSessions: expectedExerciseSessions)
    DataRepositoryContainer.shared.exerciseSessionRepository.register { exerciseSessionRepositoryStub }

    defer {
      Container.shared.userStore.reset()
      DataRepositoryContainer.shared.exerciseRepository.reset()
      DataRepositoryContainer.shared.exerciseSessionRepository.reset()
    }

    let viewModel = ExploreViewModel()
    await viewModel.initialLoad()

    XCTAssertEqual(viewModel.goals.count, 1)
    XCTAssertEqual(viewModel.favoriteExercises.count, 1)
    XCTAssertEqual(viewModel.featuredExercises.count, 1)
    XCTAssertEqual(viewModel.recommendedExercisesByGoals.count, 1)
    XCTAssertEqual(viewModel.recentSessions.count, 1)
  }

  func testSearchQuery() async throws {
    let expectedExercises = [ExerciseFactory.createExercise()]
    let exerciseRepositoryStub = ExerciseRepositoryStub(expectedExercises: expectedExercises)

    DataRepositoryContainer.shared.exerciseRepository.register { exerciseRepositoryStub }
    defer { DataRepositoryContainer.shared.exerciseRepository.reset() }

    let viewModel = ExploreViewModel()
    viewModel.searchByMuscleQuery("query")

    let task = try XCTUnwrap(viewModel.searchQueryTask)
    await task.value

    XCTAssertEqual(viewModel.featuredExercises.count, 1)
  }
}

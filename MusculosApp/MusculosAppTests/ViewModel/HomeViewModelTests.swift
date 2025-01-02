//
//  HomeViewModelTests.swift
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

// MARK: - HomeViewModelTests

@MainActor
class HomeViewModelTests: XCTestCase {
  func testFetchData() async throws {
    let currentUser = setupCurrentUser()

    let stubExerciseRepository = ExerciseRepositoryStub(expectedExercises: [
      ExerciseFactory.createExercise(),
    ])
    let stubGoalRepository = GoalRepositoryStub(expectedGoals: [
      GoalFactory.createGoal(user: currentUser),
    ])

    DataRepositoryContainer.shared.exerciseRepository.register { stubExerciseRepository }
    DataRepositoryContainer.shared.goalRepository.register { stubGoalRepository }
    defer {
      DataRepositoryContainer.shared.exerciseRepository.reset()
      DataRepositoryContainer.shared.goalRepository.reset()
    }

    let viewModel = HomeViewModel()
    await viewModel.fetchData()

    #expect(!viewModel.goals.isEmpty)

    let quickExercises = try #require(viewModel.quickExercises)
    #expect(!quickExercises.isEmpty)
  }

  private func setupCurrentUser() -> UserProfile {
    let userProfile = UserProfileFactory.createUser()
    StorageContainer.shared.userManager.register {
      StubUserSessionManager(
        expectedTokenValue: "value",
        expectedUser: .init(id: userProfile.userId))
    }
    return userProfile
  }

}

//
//  RatingRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
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

// MARK: - RatingRepositoryTests

class RatingRepositoryTests: XCTestCase {
  func testGetExerciseRatingsForCurrentUserWhenConnectedToTheInternet() async throws {
    let currentUser = UserProfileFactory.createUser()
    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: currentUser.id))
    }
    defer {
      NetworkContainer.shared.userManager.reset()
    }

    let expectation = self.expectation(description: "should call getExercisesRatings")
    let expectedResults = [ExerciseRatingFactory.createExerciseRating()]
    let mockService = MockRatingService(expectation: expectation, expectedResult: expectedResults)

    NetworkContainer.shared.ratingService.register { mockService }
    defer {
      NetworkContainer.shared.ratingService.reset()
    }

    let ratings = try await RatingRepository().getExerciseRatingsForCurrentUser()

    XCTAssertFalse(ratings.isEmpty)
    await fulfillment(of: [expectation], timeout: 1)
  }

  func testGetRatingsForExerciseWhenNotConnectedToTheInternet() async throws {
    NetworkContainer.shared.networkMonitor.register { StubNetworkMonitor(isConnected: false) }
    defer { NetworkContainer.shared.networkMonitor.reset() }

    let exerciseRating = ExerciseRatingFactory.createExerciseRating()
    let expectation = self.expectation(description: "should NOT call getExercisesRatings")
    expectation.isInverted = true

    let mockService = MockRatingService(expectation: expectation, expectedResult: [exerciseRating])
    NetworkContainer.shared.ratingService.register { mockService }
    defer {
      NetworkContainer.shared.ratingService.reset()
    }

    let ratings = try await RatingRepository().getRatingsForExercise(exerciseRating.exerciseID)
    XCTAssertTrue(ratings.contains(where: { $0.id == exerciseRating.id }))
    await fulfillment(of: [expectation], timeout: 0.1)
  }

  func testGetRatingForExercise() async throws {
    let exerciseRating = ExerciseRatingFactory.createExerciseRating(isPersistent: false)
    let expectation = self.expectation(description: "should call getExercisesRatings")

    let mockService = MockRatingService(expectation: expectation, expectedResult: [exerciseRating])
    NetworkContainer.shared.ratingService.register { mockService }
    defer {
      NetworkContainer.shared.ratingService.reset()
    }

    let repository = RatingRepository()
    let ratings = try await repository.getRatingsForExercise(exerciseRating.exerciseID)
    XCTAssertTrue(ratings.contains(where: { $0.id == exerciseRating.id }))
    await fulfillment(of: [expectation], timeout: 1)
  }

  func testGetExericseRatingsForCurrentUserWhenNotConnectedToTheInternet() async throws {
    throw XCTSkip("Causes other tests to fail. The NetworkMonitor instance is not cleared, no idea why")

    let userProfile = UserProfileFactory.createUser()
    let expectation = self.expectation(description: "should call getExercisesRatings")
    expectation.isInverted = true
    let mockService = MockRatingService(expectation: expectation, expectedResult: [])

    NetworkContainer.shared.ratingService.register { mockService }
    NetworkContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: userProfile.id))
    }
    NetworkContainer.shared.networkMonitor.register {
      StubNetworkMonitor(isConnected: false)
    }
    defer {
      NetworkContainer.shared.ratingService.reset()
      NetworkContainer.shared.userManager.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    let exercise = ExerciseFactory.createExercise()

    let rating = ExerciseRatingFactory.make { factory in
      factory.userID = userProfile.id
      factory.exerciseID = exercise.id
    }

    let repository = RatingRepository()
    let ratings = try await repository.getExerciseRatingsForCurrentUser()

    XCTAssertFalse(ratings.isEmpty)
    await fulfillment(of: [expectation], timeout: 0.1)
  }
}

// MARK: RatingRepositoryTests.MockRatingService

extension RatingRepositoryTests {
  private struct MockRatingService: RatingServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedResult: [ExerciseRating]

    func addExerciseRating(_: ExerciseRating) async throws { }

    func getRatingsByExerciseID(_: UUID) async throws -> [ExerciseRating] {
      expectation?.fulfill()
      return expectedResult
    }

    func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
      expectation?.fulfill()
      return expectedResult
    }
  }
}

//
//  RatingRepositoryTests.swift
//  DataRepository
//
//  Created by Solomon Alexandru on 02.01.2025.
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

class RatingRepositoryTests: XCTestCase {
  @Injected(\StorageContainer.coreDataStore) private var coreDataStore

  func testGetExerciseRatingsForCurrentUserWhenConnectedToTheInternet() async throws {
    let currentUser = UserProfileFactory.createUser()
    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: currentUser.userId))
    }
    defer {
      StorageContainer.shared.userManager.reset()
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
    await fulfillment(of: [expectation])
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
    XCTAssertTrue(ratings.contains(where: { $0.ratingID == exerciseRating.ratingID }))
    await fulfillment(of: [expectation], timeout: 0.1)
  }

  func testGetRatingForExercise() async throws {
    let exerciseRating = ExerciseRatingFactory.createExerciseRating()
    let expectation = self.expectation(description: "should call getExercisesRatings")

    let mockService = MockRatingService(expectation: expectation, expectedResult: [exerciseRating])
    NetworkContainer.shared.ratingService.register { mockService }
    defer {
      NetworkContainer.shared.ratingService.reset()
    }

    let repository = RatingRepository()
    let ratings = try await repository.getRatingsForExercise(exerciseRating.exerciseID)
    XCTAssertTrue(ratings.contains(where: { $0.ratingID == exerciseRating.ratingID }))
    await fulfillment(of: [expectation], timeout: 1)
  }

  func testGetExericseRatingsForCurrentUserWhenNotConnectedToTheInternet() async throws {
    throw XCTSkip("Causes other tests to fail. Something with the expectation")

    let userProfile = UserProfileFactory.createUser()
    let expectation = self.expectation(description: "should call getExercisesRatings")
    expectation.isInverted = true
    let mockService = MockRatingService(expectation: expectation, expectedResult: [])

    NetworkContainer.shared.ratingService.register { mockService }
    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedUser: .init(id: userProfile.userId))
    }
    NetworkContainer.shared.networkMonitor.register {
      StubNetworkMonitor(isConnected: false)
    }
    defer {
      NetworkContainer.shared.ratingService.reset()
      StorageContainer.shared.userManager.reset()
      NetworkContainer.shared.networkMonitor.reset()
    }

    let exercise = ExerciseFactory.createExercise()
    let ratingFactory = ExerciseRatingFactory()
    ratingFactory.userID = userProfile.userId
    ratingFactory.exerciseID = exercise.id
    let rating = ratingFactory.create()

    let repository = RatingRepository()
    let ratings = try await repository.getExerciseRatingsForCurrentUser()

    XCTAssertFalse(ratings.isEmpty)
    await fulfillment(of: [expectation], timeout: 0.1)
  }
}

extension RatingRepositoryTests {
  private struct MockRatingService: RatingServiceProtocol {
    var expectation: XCTestExpectation?
    var expectedResult: [ExerciseRating]

    func addExerciseRating(_ exerciseRating: ExerciseRating) async throws { }

    func getRatingsByExerciseID(_ exerciseID: UUID) async throws -> [ExerciseRating] {
      expectation?.fulfill()
      return expectedResult
    }

    func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
      expectation?.fulfill()
      return expectedResult
    }
  }
}

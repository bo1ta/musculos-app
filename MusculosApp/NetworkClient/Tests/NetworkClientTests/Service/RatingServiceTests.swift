//
//  RatingServiceTests.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 28.12.2024.
//

import Testing
import Foundation
import Factory
import UIKit

@testable import NetworkClient
@testable import Models
@testable import Utility
@testable import Storage

@Suite(.serialized)
final class RatingServiceTests: MusculosTestBase {
  @Test func addExerciseRating() async throws {
    let exerciseRating = ExerciseRatingFactory.createExerciseRating()

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .ratings(.index)
    stubClient.expectedBody = [
      "ratingID": exerciseRating.ratingID.uuidString as Any,
      "exerciseID": exerciseRating.exerciseID.uuidString as Any,
      "rating": exerciseRating.rating as Any,
      "isPublic": exerciseRating.isPublic as Any
    ]

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = RatingService()
    try await service.addExerciseRating(exerciseRating)
  }
}

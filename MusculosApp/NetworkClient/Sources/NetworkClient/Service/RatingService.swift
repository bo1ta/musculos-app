//
//  RatingService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 23.11.2024.
//

import Models
import Foundation
import Factory

public protocol RatingServiceProtocol: Sendable {
  func addExerciseRating(_ exerciseRating: ExerciseRating) async throws
  func getRatingsByExerciseID(_ exerciseID: UUID) async throws -> [ExerciseRating]
  func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating]
}

public struct RatingService: APIService, RatingServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client

  public func addExerciseRating(_ exerciseRating: ExerciseRating) async throws {
    var request = APIRequest(method: .post, endpoint: .ratings(.index))
    request.body = [
      "ratingID": exerciseRating.ratingID,
      "exerciseID": exerciseRating.exerciseID,
      "rating": exerciseRating.rating,
      "isPublic": exerciseRating.isPublic
    ]
    try await client.dispatch(request)
  }

  public func getRatingsByExerciseID(_ exerciseID: UUID) async throws -> [ExerciseRating] {
    let request = APIRequest(method: .get, endpoint: .ratings(.exerciseID(exerciseID)))
    let data = try await client.dispatch(request)
    return try ExerciseRating.createArrayFrom(data)
  }

  public func getExerciseRatingsForCurrentUser() async throws -> [ExerciseRating] {
    let request = APIRequest(method: .get, endpoint: .ratings(.index))
    let data = try await client.dispatch(request)
    return try ExerciseRating.createArrayFrom(data)
  }
}

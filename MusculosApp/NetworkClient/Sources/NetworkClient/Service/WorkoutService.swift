//
//  WorkoutChallengeService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 20.01.2025.
//

import Factory
import Models
import Utility

// MARK: - WorkoutServiceProtocol

public protocol WorkoutServiceProtocol {
  func generateWorkoutChallenge() async throws -> WorkoutChallenge
  func getAllWorkoutChallenges() async throws -> [WorkoutChallenge]
}

// MARK: - WorkoutService

public struct WorkoutService: APIService, WorkoutServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func generateWorkoutChallenge() async throws -> WorkoutChallenge {
    let request = APIRequest(method: .post, endpoint: .workoutChallenges(.generate))
    let data = try await client.dispatch(request)
    return try WorkoutChallenge.createFrom(data)
  }

  public func getAllWorkoutChallenges() async throws -> [WorkoutChallenge] {
    let request = APIRequest(method: .get, endpoint: .workoutChallenges(.index))
    let data = try await client.dispatch(request)
    return try WorkoutChallenge.createArrayFrom(data)
  }
}

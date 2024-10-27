//
//  GoalService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 26.10.2024.
//

import Foundation
import Models
import Factory

public protocol GoalServiceProtocol: Sendable {
  func getOnboardingGoals() async throws -> [OnboardingGoal]
  func getUserGoals() async throws -> [Goal]
  func addGoal(_ goal: Goal) async throws
  func getGoalByID(_ goalID: UUID) async throws -> Goal
  func addProgressEntry(_ entry: ProgressEntry, for goalID: UUID) async throws
}

public struct GoalService: APIService, GoalServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func getOnboardingGoals() async throws -> [OnboardingGoal] {
    let request = APIRequest(method: .get, endpoint: .templates(.goals))
    let data = try await client.dispatch(request)
    return try OnboardingGoal.createArrayFrom(data)
  }

  public func getUserGoals() async throws -> [Goal] {
    let request = APIRequest(method: .get, endpoint: .goals(.index))
    let data = try await client.dispatch(request)
    return try Goal.createArrayFrom(data)
  }

  public func addGoal(_ goal: Goal) async throws {
    var request = APIRequest(method: .post, endpoint: .goals(.index))
    try await client.dispatch(request)
  }
  
  public func getGoalByID(_ goalID: UUID) async throws -> Goal {
    let request = APIRequest(method: .get, endpoint: .goals(.goalDetails(goalID)))
    let data = try await client.dispatch(request)
    return try Goal.createFrom(data)
  }
  
  public func addProgressEntry(_ entry: ProgressEntry, for goalID: UUID) async throws {
    var request = APIRequest(method: .post, endpoint: .goals(.updateProgress))
    request.body = [
      "goalID": goalID,
      "dateAdded": entry.dateAdded,
      "value": entry.value
    ]
    try await client.dispatch(request)
  }
}

extension GoalService {
  private struct GoalResponse: Decodable {
    
  }
}

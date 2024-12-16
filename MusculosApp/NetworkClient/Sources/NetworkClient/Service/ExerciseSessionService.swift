//
//  ExerciseSessionService.swift
//  NetworkClient
//
//  Created by Solomon Alexandru on 12.10.2024.
//

import Foundation
import Models
import Factory
import Utility

public protocol ExerciseSessionServiceProtocol: Sendable {
  func getAll() async throws -> [ExerciseSession]
  func add(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry
}

public struct ExerciseSessionService: ExerciseSessionServiceProtocol, APIService, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func getAll() async throws -> [ExerciseSession] {
    let request = APIRequest(method: .get, endpoint: .exerciseSessions(.index))
    let data = try await client.dispatch(request)
    return try ExerciseSession.createArrayFrom(data)
  }

  public func add(_ exerciseSession: ExerciseSession) async throws -> UserExperienceEntry {
    var request = APIRequest(method: .post, endpoint: .exerciseSessions(.index))
    request.body = [
      "dateAdded": exerciseSession.dateAdded.ISO8601Format() as Any,
      "duration": exerciseSession.duration as Any,
      "exerciseID": exerciseSession.exercise.id.uuidString as Any,
      "sessionID": exerciseSession.sessionId.uuidString as Any
    ]

    let data = try await client.dispatch(request)
    return try UserExperienceEntry.createFrom(data)
  }
}

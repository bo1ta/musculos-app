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
  func add(_ exerciseSession: ExerciseSession) async throws
}

public struct ExerciseSessionService: ExerciseSessionServiceProtocol, MusculosService, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func getAll() async throws -> [ExerciseSession] {
    let request = APIRequest(method: .get, endpoint: .exerciseSession)
    let data = try await client.dispatch(request)
    return try ExerciseSession.createArrayFrom(data)
  }

  public func add(_ exerciseSession: ExerciseSession) async throws {
    var request = APIRequest(method: .post, endpoint: .exerciseSession)
    request.body = [
      "dateAdded": exerciseSession.dateAdded.ISO8601Format() as Any,
      "duration": exerciseSession.duration as Any,
      "exerciseID": exerciseSession.exercise.id.uuidString as Any,
      "sessionID": exerciseSession.sessionId.uuidString as Any
    ]

    try await client.dispatch(request)
  }
}

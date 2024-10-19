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
  func add(exerciseID: UUID, duration: Double, dateAdded: Date) async throws -> ExerciseSession
}

public struct ExerciseSessionService: ExerciseSessionServiceProtocol, MusculosService, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func getAll() async throws -> [ExerciseSession] {
    let request = APIRequest(method: .get, endpoint: .exerciseSession)
    let data = try await client.dispatch(request)
    return try ExerciseSession.createArrayFrom(data)
  }

  public func add(exerciseID: UUID, duration: Double, dateAdded: Date = Date()) async throws -> ExerciseSession {
    var request = APIRequest(method: .post, endpoint: .exerciseSession)
    request.body = [
      "dateAdded": dateAdded.ISO8601Format() as Any,
      "duration": duration as Any,
      "exerciseID": exerciseID.uuidString as Any
    ]

    let data = try await client.dispatch(request)
    return try ExerciseSession.createFrom(data)
  }
}

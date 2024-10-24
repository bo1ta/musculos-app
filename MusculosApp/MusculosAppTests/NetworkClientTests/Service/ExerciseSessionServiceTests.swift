//
//  ExerciseSessionServiceTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Testing
import Foundation
import Factory

@testable import NetworkClient
@testable import Models
@testable import Utility
@testable import Storage

@Suite(.serialized)
final class ExerciseSessionServiceTests: MusculosTestBase {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  @Test func getAll() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .exerciseSession
    stubClient.expectedResponseData = try parseDataFromFile(name: "exerciseSessions")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let exerciseSessions = try await ExerciseSessionService().getAll()
    #expect(exerciseSessions.count == 1)
  }

  @Test func add() async throws {
    let exercise = ExerciseFactory.createExercise()
    let exerciseSession = ExerciseSessionFactory.createExerciseSession(exercise: exercise)

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .exerciseSession
    stubClient.expectedBody = [
      "dateAdded": exerciseSession.dateAdded.ISO8601Format(),
      "duration": exerciseSession.duration,
      "exerciseID": exercise.id.uuidString,
      "sessionID": exerciseSession.sessionId.uuidString
    ]

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    try await ExerciseSessionService().add(exerciseSession)
  }
}

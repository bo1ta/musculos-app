//
//  ExerciseSessionServiceTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Factory
import Foundation
import Testing

@testable import Models
@testable import NetworkClient
@testable import Storage
@testable import Utility

@Suite(.serialized)
final class ExerciseSessionServiceTests: MusculosTestBase {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  @Test
  func getAll() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .exerciseSessions(.index)
    stubClient.expectedResponseData = try parseDataFromFile(name: "exerciseSessions")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let exerciseSessions = try await ExerciseSessionService().getAll()
    #expect(exerciseSessions.count == 1)
  }

  @Test
  func add() async throws {
    let exercise = ExerciseFactory.createExercise()

    let factory = ExerciseSessionFactory()
    factory.exercise = exercise
    let exerciseSession = factory.create()

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .exerciseSessions(.index)
    stubClient.expectedBody = [
      "dateAdded": exerciseSession.dateAdded.ISO8601Format(),
      "duration": exerciseSession.duration,
      "exerciseID": exercise.id.uuidString,
      "sessionID": exerciseSession.sessionId.uuidString,
    ]
    stubClient.expectedResponseData = try parseDataFromFile(name: "userExperienceEntry")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    _ = try await ExerciseSessionService().add(exerciseSession)
  }
}

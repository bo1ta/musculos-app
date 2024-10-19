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
    let mockDate = Date()
    let exerciseID = "6B5765CB-CD52-4F1D-8B33-14D771063943"

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .exerciseSession
    stubClient.expectedBody = [
      "dateAdded": mockDate.ISO8601Format(),
      "duration": 15,
      "exerciseID": exerciseID as Any
    ]

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let exerciseSession = ExerciseSessionFactory.createExerciseSession(exercise: ExerciseFactory.createExercise(id: UUID(uuidString: exerciseID)!))
    try await ExerciseSessionService().add(exerciseSession)
  }
}

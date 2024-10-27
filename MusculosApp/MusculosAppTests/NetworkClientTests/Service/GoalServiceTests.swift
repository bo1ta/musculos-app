//
//  GoalServiceTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.10.2024.
//

import Testing
import Foundation
import Factory

@testable import NetworkClient
@testable import Models
@testable import Utility
@testable import Storage

@Suite(.serialized)
final class GoalServiceTests: MusculosTestBase {
  @Test func getOnboardingGoals() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .templates(.goals)
    stubClient.expectedResponseData = try parseDataFromFile(name: "goalsTemplates")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = GoalService()
    let goalTemplates = try await service.getOnboardingGoals()
    #expect(goalTemplates.count == 3)
  }

  @Test func getUserGoals() async throws {
    let stubSession = StubUserSessionManager(expectedTokenValue: "super-secret-token")
    StorageContainer.shared.userManager.register { stubSession }
    defer {
      StorageContainer.shared.userManager.reset()
    }

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .goals(.index)
    stubClient.expectedResponseData = try parseDataFromFile(name: "goals")
    stubClient.expectedAuthToken = stubSession.expectedTokenValue

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = GoalService()
    let goals = try await service.getUserGoals()
    #expect(goals.count == 2)
  }
}

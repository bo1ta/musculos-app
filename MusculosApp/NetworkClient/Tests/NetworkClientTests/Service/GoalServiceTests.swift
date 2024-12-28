//
//  GoalServiceTests.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 27.10.2024.
//

import Factory
import Foundation
import Testing

@testable import Models
@testable import NetworkClient
@testable import Storage
@testable import Utility

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

  @Test func addGoal() async throws {
    let userProfile = UserProfileFactory.createUser()
    let goal = GoalFactory.createGoal(user: userProfile)

    var stubSession = StubUserSessionManager(expectedTokenValue: "super-secret-token")
    stubSession.expectedUser = .init(id: userProfile.userId)
    StorageContainer.shared.userManager.register { stubSession }
    defer {
      StorageContainer.shared.userManager.reset()
    }

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .goals(.index)
    stubClient.expectedAuthToken = stubSession.expectedTokenValue

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = GoalService()
    try await service.addGoal(goal)
  }

  @Test func getGoalByID() async throws {
    let expectedGoaID = try #require(UUID(uuidString: "038E927E-4E82-48C6-8E47-5B21670E688C"))
    let stubSession = StubUserSessionManager(expectedTokenValue: "super-secret-token")
    StorageContainer.shared.userManager.register { stubSession }
    defer {
      StorageContainer.shared.userManager.reset()
    }

    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .goals(.goalDetails(expectedGoaID))
    stubClient.expectedAuthToken = stubSession.expectedTokenValue
    stubClient.expectedResponseData = try parseDataFromFile(name: "goal")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = GoalService()
    let serviceGoal = try await service.getGoalByID(expectedGoaID)
    #expect(serviceGoal.id.uuidString == expectedGoaID.uuidString)
  }

  @Test func addProgressEntry() async throws {
    let goal = GoalFactory.createGoal()
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .goals(.updateProgress)

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let service = GoalService()
    try await service.addProgressEntry(ProgressEntry(dateAdded: Date(), value: 20, goal: goal))
  }
}

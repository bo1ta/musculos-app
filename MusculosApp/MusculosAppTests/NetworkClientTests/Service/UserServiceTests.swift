//
//  UserServiceTests.swift
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
final class UserServiceTests: MusculosTestBase {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  @Test func register() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .register
    stubClient.expectedBody = [
      "email": "test@test.com",
      "password": "test",
      "username": "tester"
    ]
    stubClient.expectedResponseData = try parseDataFromFile(name: "authenticationResult")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let userSession = try await UserService().register(email: "test@test.com", password: "test", username: "tester")
    #expect(userSession.user.id.uuidString == "E64DE495-D63C-4C12-B8EA-957668EDDF71")
    #expect(userSession.token.value == "super-secret-token")
  }

  @Test func login() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .login
    stubClient.expectedBody = [
      "email": "test@test.com",
      "password": "test"
    ]
    stubClient.expectedResponseData = try parseDataFromFile(name: "authenticationResult")

    NetworkContainer.shared.client.register { stubClient }
    defer {
      NetworkContainer.shared.client.reset()
    }

    let userSession = try await UserService().login(email: "test@test.com", password: "test")
    #expect(userSession.user.id.uuidString == "E64DE495-D63C-4C12-B8EA-957668EDDF71")
    #expect(userSession.token.value == "super-secret-token")
  }

  @Test func currentUser() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .get
    stubClient.expectedEndpoint = .currentProfile
    stubClient.expectedAuthToken = "super-secret-token"
    stubClient.expectedResponseData = try parseDataFromFile(name: "userProfile")

    NetworkContainer.shared.client.register { stubClient }
    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedTokenValue: "super-secret-token")
    }
    defer {
      NetworkContainer.shared.client.reset()
      StorageContainer.shared.userManager.reset()
    }

    let userProfile = try await UserService().currentUser()
    #expect(userProfile.userId.uuidString == "31A6745A-13BD-4D03-982B-F4C9DFE75B14")
    #expect(userProfile.isOnboarded == false)
    #expect(userProfile.email == "test@test.com")
    #expect(userProfile.username == "tester")
    #expect(userProfile.xp == 0)
  }

  @Test func updateUser() async throws {
    var stubClient = StubMusculosClient()
    stubClient.expectedMethod = .post
    stubClient.expectedEndpoint = .updateProfile
    stubClient.expectedAuthToken = "super-secret-token"
    stubClient.expectedResponseData = try parseDataFromFile(name: "userProfile")
    stubClient.expectedBody = [
      "isOnboarded": true,
      "level": ExerciseConstants.LevelType.beginner.rawValue,
      "primaryGoal": Goal.Category.growMuscle.rawValue,
      "height": 50,
      "weight": 50
    ]

    NetworkContainer.shared.client.register { stubClient }
    StorageContainer.shared.userManager.register {
      StubUserSessionManager(expectedTokenValue: "super-secret-token")
    }
    defer {
      NetworkContainer.shared.client.reset()
      StorageContainer.shared.userManager.reset()
    }

    let userProfile = try await UserService().updateUser(
      weight: 50,
      height: 50,
      primaryGoal: Goal.Category.growMuscle.rawValue,
      level: ExerciseConstants.LevelType.beginner.rawValue,
      isOnboarded: true
    )
    #expect(userProfile.userId.uuidString == "31A6745A-13BD-4D03-982B-F4C9DFE75B14")
    #expect(userProfile.isOnboarded == false)
    #expect(userProfile.email == "test@test.com")
    #expect(userProfile.username == "tester")
    #expect(userProfile.xp == 0)
  }
}

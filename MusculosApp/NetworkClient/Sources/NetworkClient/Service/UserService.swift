//
//  UserService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Factory
import Foundation
import Models

public protocol UserServiceProtocol: Sendable {
  func register(email: String, password: String, username: String) async throws -> UserSession
  func login(email: String, password: String) async throws -> UserSession
  func currentUser() async throws -> UserProfile
  func updateUser(weight: Int?, height: Int?, primaryGoalID: UUID?, level: String?, isOnboarded: Bool) async throws -> UserProfile
}

public struct UserService: APIService, UserServiceProtocol, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    var request = APIRequest(method: .post, endpoint: .users(.register))
    request.body = [
      "email": email,
      "password": password,
      "username": username,
    ]

    let data = try await client.dispatch(request)
    return try UserSession.createFrom(data)
  }

  public func login(email: String, password: String) async throws -> UserSession {
    var request = APIRequest(method: .post, endpoint: .users(.login))
    request.body = [
      "email": email,
      "password": password,
    ]

    let data = try await client.dispatch(request)
    return try UserSession.createFrom(data)
  }

  public func currentUser() async throws -> UserProfile {
    let request = APIRequest(method: .get, endpoint: .users(.currentProfile))
    let data = try await client.dispatch(request)
    return try UserProfile.createFrom(data)
  }

  public func updateUser(
    weight: Int? = nil,
    height: Int? = nil,
    primaryGoalID: UUID? = nil,
    level: String? = nil,
    isOnboarded: Bool = false
  ) async throws -> UserProfile {
    var request = APIRequest(method: .post, endpoint: .users(.updateProfile))
    request.body = [
      "isOnboarded": isOnboarded,
    ]
    if let weight {
      request.body?["weight"] = weight
    }
    if let height {
      request.body?["height"] = height
    }
    if let primaryGoalID {
      request.body?["primaryGoalID"] = primaryGoalID.uuidString
    }
    if let level {
      request.body?["level"] = level
    }

    let data = try await client.dispatch(request)
    return try UserProfile.createFrom(data)
  }
}

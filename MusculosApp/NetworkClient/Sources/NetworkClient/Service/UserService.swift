//
//  UserService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 15.09.2024.
//

import Foundation
import Models
import Factory

public protocol UserServiceProtocol: Sendable {
  func register(email: String, password: String, username: String) async throws -> UserSession
  func login(email: String, password: String) async throws -> UserSession
  func currentUser() async throws -> UserProfile
  func updateUser(weight: Int?, height: Int?, primaryGoalID: UUID?, level: String?, isOnboarded: Bool) async throws -> UserProfile
}

public struct UserService: UserServiceProtocol, MusculosService, @unchecked Sendable {
  @Injected(\NetworkContainer.client) var client: MusculosClientProtocol

  public func register(email: String, password: String, username: String) async throws -> UserSession {
    var request = APIRequest(method: .post, endpoint: .register)
    request.body = [
      "email": email,
      "password": password,
      "username": username
    ]

    let data = try await client.dispatch(request)
    return try UserSession.createFrom(data)
  }

  public func login(email: String, password: String) async throws -> UserSession {
    var request = APIRequest(method: .post, endpoint: .login)
    request.body = [
      "email": email,
      "password": password
    ]

    let data = try await client.dispatch(request)
    return try UserSession.createFrom(data)
  }

  public func currentUser() async throws -> UserProfile {
    let request = APIRequest(method: .get, endpoint: .currentProfile)
    let data = try await client.dispatch(request)
    return try await UserProfile.createFrom(data)
  }

  public func updateUser(
    weight: Int? = nil,
    height: Int? = nil,
    primaryGoalID: UUID? = nil,
    level: String? = nil,
    isOnboarded: Bool = false
  ) async throws -> UserProfile {

    var request = APIRequest(method: .post, endpoint: .updateProfile)
    request.body = [
      "isOnboarded": isOnboarded as Any,
      "level": level as Any,
      "primaryGoalID": primaryGoalID as Any,
      "height": height as Any,
      "weight": weight as Any
    ]

    let data = try await client.dispatch(request)
    return try await UserProfile.createFrom(data)
  }
}

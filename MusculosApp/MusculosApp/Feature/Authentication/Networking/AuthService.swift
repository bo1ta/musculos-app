//
//  AuthService.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 10.06.2023.
//

import Foundation
import Utility
import Models
import Storage
@preconcurrency import Factory

protocol AuthServiceProtocol: Sendable {
  func register(email: String, password: String, username: String) async throws -> UserSession
  func login(email: String, password: String) async throws -> UserSession
}

struct AuthService: MusculosService, AuthServiceProtocol {
  @Injected(\.client) var client: MusculosClientProtocol

  func register(email: String, password: String, username: String) async throws -> UserSession {
    var request = APIRequest(method: .post, path: .register)
    request.body = [
      "email": email,
      "password": password,
      "username": username
    ]

    let data = try await client.dispatch(request)
    let authResult = try AuthenticationResult.createFrom(data)

    return UserSession(
      authToken: authResult.token,
      userId: UUID(),
      email: email,
      username: username,
      isOnboarded: false
    )
  }

  func login(email: String, password: String) async throws -> UserSession {
    var request = APIRequest(method: .post, path: .login)
    request.body = [
      "email": email,
      "password": password
    ]

    let data = try await client.dispatch(request)
    let result = try AuthenticationResult.createFrom(data)

    return UserSession(
      authToken: result.token,
      userId: UUID(),
      email: email,
      isOnboarded: false
    )
  }
}

// MARK: - AuthenticationResult
//
extension AuthService {
  struct AuthenticationResult: Codable, DecodableModel {
    var token: String
  }
}

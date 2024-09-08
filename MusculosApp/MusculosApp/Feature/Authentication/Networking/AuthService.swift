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
    return try UserSession.createFrom(data)
  }

  func login(email: String, password: String) async throws -> UserSession {
    var request = APIRequest(method: .post, path: .login)
    request.body = [
      "email": email,
      "password": password
    ]

    let data = try await client.dispatch(request)
    return try UserSession.createFrom(data)
  }
}

// MARK: - AuthenticationResult
//
extension AuthService {
  struct AuthenticationResult: Codable, DecodableModel {
    var value: String
    var createdAt: Date?
    var expiresAt: Date?
  }
}

//
//  UserSession.swift
//
//
//  Created by Solomon Alexandru on 08.09.2024.
//

import Foundation
import Utility

public struct UserSession: Sendable, Codable, DecodableModel {
  public var token: Token
  public var user: User

  public var userID: UUID {
    user.id
  }

  public init(token: Token, user: User) {
    self.token = token
    self.user = user
  }

  public struct Token: Codable, Sendable {
    public var createdAt: String?
    public var expiresAt: String?
    public var value: String

    public init(createdAt: String? = nil, expiresAt: String? = nil, value: String) {
      self.createdAt = createdAt
      self.expiresAt = expiresAt
      self.value = value
    }
  }

  public struct User: Codable, Sendable {
    public var id: UUID

    public init(id: UUID) {
      self.id = id
    }
  }

  /// Tests helper
  ///
  public static var mock: UserSession {
    UserSession(
      token: Token(
        createdAt: Date().ISO8601Format(),
        expiresAt: Date.distantFuture.ISO8601Format(),
        value: "token"),
      user: User(id: UUID()))
  }

  public static func mockWithUserID(_ userID: UUID) -> UserSession {
    UserSession(
      token: Token(
        createdAt: Date().ISO8601Format(),
        expiresAt: Date.distantFuture.ISO8601Format(),
        value: "token"),
      user: User(id: userID))
  }
}

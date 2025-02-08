//
//  StubUserSessionManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Foundation
import Models

public struct StubUserSessionManager: UserSessionManagerProtocol, @unchecked Sendable {
  public var expectedTokenValue: String?
  public var expectedUser: UserSession.User?

  public init(expectedTokenValue: String? = nil, expectedUser: UserSession.User? = nil) {
    self.expectedTokenValue = expectedTokenValue
    self.expectedUser = expectedUser
  }

  public init(expectedTokenValue: String? = nil, expectedUserID: UUID) {
    self.expectedTokenValue = expectedTokenValue
    self.expectedUser = .init(id: expectedUserID)
  }

  public func getCurrentState() -> UserSessionState {
    UserSessionState.authenticated(
      UserSession(
        token: UserSession.Token(value: expectedTokenValue ?? "token"),
        user: expectedUser ?? UserSession.User(id: UUID())))
  }

  public func updateSession(_: UserSession) { }

  public func clearSession() { }
}

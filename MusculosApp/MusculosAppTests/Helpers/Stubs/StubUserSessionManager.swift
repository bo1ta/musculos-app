//
//  StubUserSessionManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 16.10.2024.
//

import Foundation
@testable import Storage
@testable import Models

struct StubUserSessionManager: UserSessionManagerProtocol, @unchecked Sendable {
  var expectedTokenValue: String?

  func currentState() -> UserSessionState {
    UserSessionState.authenticated(
      UserSession(
        token: UserSession.Token(value: expectedTokenValue ?? "token"),
        user: UserSession.User(id: UUID())
      )
    )
  }

  func updateSession(_ session: UserSession) { }

  func clearSession() { }
}

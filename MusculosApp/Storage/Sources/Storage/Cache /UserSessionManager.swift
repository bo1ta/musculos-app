//
//  UserSessionManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Foundation
import Utility
import Models

public enum UserSessionState: Sendable {
  case authenticated(UserSession)
  case unauthenticated
}

public protocol UserSessionManagerProtocol: Sendable {
  func currentState() -> UserSessionState
  func updateSession(_ session: UserSession)
  func clearSession()

  var isAuthenticated: Bool { get }
  var currentUserSession: UserSession? { get }
}

extension UserSessionManagerProtocol {
  public var isAuthenticated: Bool {
    if case .authenticated = currentState() {
      return true
    }
    return false
  }

  public var currentUserSession: UserSession? {
    if case .authenticated(let session) = currentState() {
      return session
    }
    return nil
  }

  public var currentUserID: UUID? {
    return currentUserSession?.user.id
  }
}

public final class UserSessionManager: @unchecked Sendable, UserSessionManagerProtocol {
  public func currentState() -> UserSessionState {
    if let session = loadSessionFromUserDefaults() {
      return .authenticated(session)
    } else {
      return .unauthenticated
    }
  }

  public func updateSession(_ session: UserSession) {
    if let data = try? JSONEncoder().encode(session) {
      UserDefaults.standard.set(data, forKey: UserDefaultsKey.userSession)
    }
  }

  public func clearSession() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSession)
  }

  private func loadSessionFromUserDefaults() -> UserSession? {
    guard
      let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userSession),
      let userSession = try? UserSession.createFrom(data)
    else { return nil }

    return userSession
  }
}

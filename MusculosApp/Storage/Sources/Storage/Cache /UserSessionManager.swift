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
  func getCurrentState() -> UserSessionState
  func updateSession(_ session: UserSession)
  func clearSession()
}

extension UserSessionManagerProtocol {
  public var isAuthenticated: Bool {
    if case .authenticated = getCurrentState() {
      return true
    }
    return false
  }

  public var currentUserSession: UserSession? {
    if case .authenticated(let session) = getCurrentState() {
      return session
    }
    return nil
  }

  public var currentUserID: UUID? {
    return currentUserSession?.user.id
  }
}

public final class UserSessionManager: UserSessionManagerProtocol, @unchecked Sendable {
  private var cachedSessionState: UserSessionState?

  public func getCurrentState() -> UserSessionState {
      if let cachedSessionState {
        return cachedSessionState
      }

      let session = loadSessionFromUserDefaults()
      cachedSessionState =  session != nil ? .authenticated(session!) : .unauthenticated
      return cachedSessionState!
  }

  public func updateSession(_ session: UserSession) {
      if let data = try? JSONEncoder().encode(session) {
        UserDefaults.standard.set(data, forKey: UserDefaultsKey.userSession)
        cachedSessionState = .authenticated(session)
      }
  }

  public func clearSession() {
      UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSession)
      cachedSessionState = nil
  }

  private func loadSessionFromUserDefaults() -> UserSession? {
    guard
      let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userSession),
      let userSession = try? UserSession.createFrom(data)
    else { return nil }

    return userSession
  }
}

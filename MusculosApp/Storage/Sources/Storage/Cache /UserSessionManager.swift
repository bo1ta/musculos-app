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
  case none
}

public protocol UserSessionManagerProtocol: Sendable {
  func currentState() -> UserSessionState
  func updateSession(_ session: UserSession)
  func clearSession()

  var isAuthenticated: Bool { get }
  var currentUserSession: UserSession? { get }
}

public final class UserSessionManager: @unchecked Sendable, UserSessionManagerProtocol {
  private let state = ManagedCriticalState<UserSessionState>(.none)

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

  public func currentState() -> UserSessionState {
    return state.withCriticalRegion { currentState in
      switch currentState {
      case .authenticated(let userSession):
        return currentState
      case .unauthenticated:
        return .unauthenticated
      case .none:
        if let session = loadSessionFromUserDefaults() {
          currentState = .authenticated(session)
          return currentState
        } else {
          currentState = .unauthenticated
          return currentState
        }
      }
    }
  }

  public func updateSession(_ session: UserSession) {
    state.withCriticalRegion { currentState in
      currentState = .authenticated(session)
      saveSessionToUserDefaults(session)
    }
  }

  public func clearSession() {
    state.withCriticalRegion { currentState in
      currentState = .none
      removeSessionFromUserDefaults()
    }
  }

  private func loadSessionFromUserDefaults() -> UserSession? {
    guard
      let data = UserDefaults.standard.data(forKey: UserDefaultsKey.userSession),
      let userSession = try? UserSession.createFrom(data)
    else { return nil }

    return userSession
  }

  private func removeSessionFromUserDefaults() {
    UserDefaults.standard.removeObject(forKey: UserDefaultsKey.userSession)
  }

  private func saveSessionToUserDefaults(_ session: UserSession) {
    if let data = try? JSONEncoder().encode(session) {
      UserDefaults.standard.set(data, forKey: UserDefaultsKey.userSession)
    }
  }
}

//
//  UserManager.swift
//  MusculosApp
//
//  Created by Solomon Alexandru on 30.07.2024.
//

import Foundation

protocol UserManagerProtocol: Sendable {
  func currentSession() -> UserSession?
  func updateSession(_ session: UserSession)
  func clearSession()
}

final class UserManager: @unchecked Sendable, UserManagerProtocol {
    private let lock = NSLock()

    private var _currentSession: UserSession?

    func currentSession() -> UserSession? {
        lock.withLock {
            if _currentSession != nil {
                return _currentSession
            } else {
                guard
                    let data = UserDefaults.standard.data(forKey: UserDefaultsKeyConstant.userSessionKey),
                    let authSession = try? UserSession.createFrom(data)
                else {
                    return nil
                }

                _currentSession = authSession
                return authSession
            }
        }
    }

  func updateSession(_ session: UserSession) {
        lock.withLock {
          if let data = try? JSONEncoder().encode(session) {
                UserDefaults.standard.set(data, forKey: UserDefaultsKeyConstant.userSessionKey)
            }

          _currentSession = session
        }
    }

    func clearSession() {
        lock.withLock {
            _currentSession = nil
            UserDefaults.standard.removeObject(forKey: UserDefaultsKeyConstant.userSessionKey)
        }
    }
}
